            // struct start
 
            struct appdata
			{
				float4 vertex : POSITION;
				float3 center : TEXCOORD0; //xyz - Particle world position center
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f 
			{
				float4 pos : SV_POSITION;
				float4 grabPos : TEXCOORD0;
				
				float4 uv : TEXCOORD1;     //[0 .. 1] overlayScreenSpace
				float3 worldRayDir: TEXCOORD2;
				float3 viewPos : TEXCOORD3;
				nointerpolation float3 viewCenter : TEXCOORD4;
				nointerpolation float falloff : TEXCOORD5;  //[0 .. 1] shader effect strength
				nointerpolation float2 grabPosForward : TEXCOORD6; // view center position in grabTexture (not for single pass stereo instancing)
				float3 viewPos2 : TEXCOORD7;
				UNITY_VERTEX_OUTPUT_STEREO
			}; 

            // struct end

			inline float aspect()
			{
				#if UNITY_SINGLE_PASS_STEREO
					return (_ScreenParams.x / _ScreenParams.y) * 2.0;
				#else
					return _ScreenParams.x / _ScreenParams.y;
				#endif
			}

			static float ratio = aspect();

            // sample texture start

            #ifdef UNITY_STEREO_INSTANCING_ENABLED
				Texture2DArray _LoonaIsHot;
				Texture2DArray _CameraDepthTexture;
				float4 SampleGrabTexture(float2 uv)
				{
					return _LoonaIsHot.SampleLevel(grabSampler, float3(uv, unity_StereoEyeIndex), 0);
				}
				float4 SampleDepthTexture(float2 uv)
				{
					return _CameraDepthTexture.SampleLevel(grabSampler, float3(uv, unity_StereoEyeIndex), 0);
				}
			#else
				Texture2D _LoonaIsHot;
				Texture2D _CameraDepthTexture;
				float4 SampleGrabTexture(float2 uv)
				{
					return _LoonaIsHot.SampleLevel(grabSampler, uv, 0);
				}
				float4 SampleDepthTexture(float2 uv)
				{
					return _CameraDepthTexture.SampleLevel(grabSampler, uv, 0);
				}
			#endif

			uniform float4 _LoonaIsHot_TexelSize;
			
			#ifdef UNITY_SINGLE_PASS_STEREO
				static const float2 factor = float2(0.5, 1.0);
			#else
				static const float2 factor = float2(1.0, 1.0);
			#endif
            //sample texture end

            bool IsInMirror() //Thanks DocMe ^w^
			{
				return unity_CameraProjection[2][0] != 0.0 || unity_CameraProjection[2][1] != 0.0;
			}

            #if defined(UNITY_SINGLE_PASS_STEREO)
			float2 TransformStereoScreenSpaceTex2(float2 uv, float w, uint eye)
			{
				float4 scaleOffset = unity_StereoScaleOffset[eye];
				return uv.xy * scaleOffset.xy + scaleOffset.zw * w;
			}
		#else
			#define TransformStereoScreenSpaceTex2(uv, w, eye) uv
		#endif

			inline float4 ComputeGrabScreenPos2(float4 pos, uint eye) 
			{
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
				float4 o = pos * 0.5f;
				o.xy = float2(o.x, o.y * scale) + o.w;
			#ifdef UNITY_SINGLE_PASS_STEREO
				o.xy = TransformStereoScreenSpaceTex2(o.xy, pos.w, eye);
			#endif
				o.zw = pos.zw;
				return o;
			}
			inline float3 _WSCameraPosition(){
				#if UNITY_SINGLE_PASS_STEREO
					return (unity_StereoWorldSpaceCameraPos[0] + unity_StereoWorldSpaceCameraPos[1])*0.5;
				#else
					return _WorldSpaceCameraPos;
				#endif
			}
			v2f vert(appdata v) 
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_OUTPUT(v2f, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				fixed3 center = 0, viewPos3 = v.vertex*10;
				
				float dist1 = distance(_WSCameraPosition(), mul(unity_ObjectToWorld, float4(center, 1)).xyz);
				
				o.pos = UnityViewToClipPos(viewPos3);
				o.viewPos2 = viewPos3;

			#ifdef USING_STEREO_MATRICES
				float3 nonStereoCameraPosition = (unity_StereoWorldSpaceCameraPos[0] + unity_StereoWorldSpaceCameraPos[1])*0.5;
			#else
				float3 nonStereoCameraPosition = _WorldSpaceCameraPos;
			#endif
				float4 viewPos = float4(v.vertex.xyz, 1);
				float3 worldCenter;
				if(Particle_Render)
				{
					viewPos.xyz -= v.center;
					worldCenter = v.center;
				}
				else
				{
					worldCenter = mul(unity_ObjectToWorld, float4(0,0,0,1));
				}
				float dist = distance(nonStereoCameraPosition, worldCenter);
				UNITY_BRANCH if(dist > _MaxRange || IsInMirror())
				{
					o.pos = float4(0, 0, -2, 1);
					return o;
				}
				float4 clipPos = UnityViewToClipPos(viewPos);
				o.grabPos = ComputeGrabScreenPos(clipPos);
				float4 grabPosFocus = ComputeGrabScreenPos(UnityViewToClipPos(float4(0, 0, 1, 1)));
				grabPosFocus /= grabPosFocus.w;
				o.grabPosForward = grabPosFocus.xy;

				float4 viewPos2 = viewPos;

				o.falloff = smoothstep(1, 0, (dist - _MinRange) / (_MaxRange - _MinRange));
				float3 viewCenter = UnityWorldToViewPos(worldCenter);
				o.viewCenter = viewCenter;
				o.viewPos = viewPos;

				
				
				[forcecase] switch(Magnification)
				{
				case MAGNIFICATION_SIMPLE_SCALE:
					_Magnification = 2.0 - 2.0 / (_Magnification + 1.0);
					o.grabPos.xy = lerp(o.grabPos.xy, grabPosFocus.xy * o.grabPos.w , o.falloff * _Magnification);
					break;
				case MAGNIFICATION_ZOOM:
					{
						float4 clipCenter = UnityViewToClipPos(viewCenter);
						float4 grabPosCenter = ComputeGrabScreenPos(clipCenter);
				
						float borderFalloff = grabPosCenter.w > 0 ? 1 : 0;
						float2 grabPosCenterNormalized = grabPosCenter.xy / max(0.0001, grabPosCenter.w);
						float4 uv = ComputeNonStereoScreenPos(clipCenter);
						uv /= uv.w;
						borderFalloff *= step(0, uv.x)*step(0, uv.y)*step(-1, -uv.x)*step(-1, -uv.y); // check in range [-1 .. 1]
						_Magnification = 2.0 - 2.0 / (_Magnification + 1.0);
						o.grabPos.xy = lerp(o.grabPos.xy, grabPosCenterNormalized * o.grabPos.w, borderFalloff * o.falloff * _Magnification);
						break;
					}
				case MAGNIFICATION_ZOOM_FALLOFF:
					{
						float angle = 1 - acos(dot(normalize(worldCenter - nonStereoCameraPosition), UNITY_MATRIX_V[2])) / UNITY_PI;
						float linearRange = (angle - _AngleStartFade) / (_MaxAngle - _AngleStartFade);
						float angleFalloff = smoothstep(1, 0, linearRange);

						float4 clipCenter = UnityViewToClipPos(viewCenter);
						float4 grabPosCenter = ComputeGrabScreenPos(clipCenter);
						float2 grabPosCenterNormalized = grabPosCenter / grabPosCenter.w;
						_Magnification = 2.0 - 2.0 / (_Magnification + 1.0);
						o.grabPos.xy = lerp(o.grabPos.xy, grabPosCenterNormalized * o.grabPos.w, angleFalloff * o.falloff * _Magnification);
						break;
					}
				case MAGNIFICATION_CENTERING:
					{
						float3 v_forward = normalize(-viewCenter);
						float angle = 1 - acos(dot(normalize(worldCenter - nonStereoCameraPosition), UNITY_MATRIX_V[2])) / UNITY_PI;
						float linearRange = (angle - _AngleStartFade) / (_MaxAngle - _AngleStartFade);
						float angleFalloff = smoothstep(1, 0, linearRange);

						v_forward = lerp(float3(0, 0, 1), v_forward, angleFalloff * o.falloff);
						float3 v_up = float3(0, 1, 0);
						float3 v_right = -normalize(cross(v_forward, v_up));
						v_up = -normalize(cross(v_right, v_forward));
				
						float3x3 matrix_v = float3x3(v_right, v_up, v_forward);
						viewPos2.xyz = mul(matrix_v, viewPos2.xyz);

						float4 clipCenter = UnityViewToClipPos(viewCenter);
						float4 grabPosCenter = ComputeGrabScreenPos(clipCenter);
						float2 grabPosCenterNormalized = grabPosCenter / grabPosCenter.w;

						o.grabPos.xy = lerp(o.grabPos.xy, grabPosCenterNormalized * o.grabPos.w, angleFalloff * o.falloff * _Magnification);
						break;
					}
				}

				UNITY_BRANCH if(ScreenRotation)
				{
					float s, c;
					sincos(_ScreenRotation*cos(_Time.y*_ScreenRotationSpeed*UNITY_TWO_PI)*o.falloff, s, c);
					viewPos2.xy = mul(float2x2(c, -s, s, c), viewPos2.xy);
				}

				o.grabPos.xy = lerp(o.grabPos.xy, o.grabPos.ww - o.grabPos.xy, float2(_ScreenHorizontalFlip, _ScreenVerticalFlip) * o.falloff);
				UNITY_BRANCH if(Shake)
				{
					float2 shake = UnpackNormal(tex2Dlod(_ShakeTex, float4(_Time.x * _ShakeScroll.xy, 0, 0)));
					shake *= float2(_SIntensity_X, _SIntensity_Y);
					shake += _ShakeWave.xy * float2(cos(_Time.y * _ShakeWaveSpeed.x), sin(_Time.y * _ShakeWaveSpeed.y));
					shake.x *= _ScreenParams.y / _ScreenParams.x;
					o.grabPos.xy += o.grabPos.w * shake * o.falloff * factor.x;
				}
				o.worldRayDir = mul((float3x3)UNITY_MATRIX_I_V, viewPos2);
				o.pos = UnityViewToClipPos(viewPos2);
				o.uv = ComputeNonStereoScreenPos(o.pos);

				return o;
			}