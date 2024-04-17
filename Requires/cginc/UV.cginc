            float calcVignette (float2 uv, float Vignette) {
				return saturate(length(uv - 0.5) - lerp(-1,2,Vignette));
			}

			float4 frag(v2f i) : COLOR
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				float2 vr_uv = i.viewPos.xy / -i.viewPos.z;
				float2 grabPos = i.grabPos.xy / i.grabPos.w;
				float2 outUV = i.grabPos.xy / i.grabPos.w;
				float2 vigUV = i.grabPos.xy / i.grabPos.w;//(i.uv.xy / abs(i.uv.z));

				//grabPos =  0.5 - ((grabPos - 0.5) * -_ZoomOutUV);

				//float2 mirrorUV = MirrorFX(grabPos);  // create mirror
				//grabPos = lerp(grabPos, mirrorUV, 1 * i.falloff); // create mirror to grabpass
				
 
				UNITY_BRANCH if (_RenderMode == 0) {
					grabPos = grabPos;
				} else if (_RenderMode == 1) {
					grabPos = fract(grabPos);
				} else if (_RenderMode == 2) {
					grabPos = saturate(grabPos);
				}

				float2 grabPosOffsetR = 0;
				float2 grabPosOffsetB = 0;
				i.uv /= i.uv.w;
				i.viewPos = normalize(i.viewPos);
				i.worldRayDir = normalize(i.worldRayDir);
				// mask screen
				float2 grab2 = i.grabPos.xy / i.grabPos.w; // get norm screen uwu
				if (_RenderMode == 4) {
					if (grab2.y < _ScreenBounds.y || grab2.y > _ScreenBounds.x || grab2.x < _ScreenBounds.y || grab2.x > _ScreenBounds.x) {
						grabPos.xy += _TMovement.xy * _TransitionScreen;
						grabPos = mul(r2d(_TransRotationBG * _TRotPower * _TransitionScreen), grabPos-0.5);
						grabPos+=0.5;
						grabPos = float2(lerp(grabPos, fract(grabPos), _TransitionScreen));
						_TBGScreenZoom = 2.0 - 2.0 / (_TBGScreenZoom + 1.0);
						grabPos = (grabPos - 0.5) / _TBGScreenZoom;
						grabPos += 0.5;
						
						UNITY_BRANCH if (_TUSEDSUV) {
							float2 TdsUV = DSNorm(grabPos, 2);
							grabPos = lerp(grabPos, TdsUV, _TDSUVOrgin * _TransitionScreen * i.falloff);
						}

						UNITY_BRANCH if (_UseTransRotate) {
							grabPos = mul(r2d(((_TransRotationFG * _TRotPower * _TransitionScreen) + sin(iTime * (_TransRotationSpeed * 10. )) * _TRotRange * _TRotPower * _TransitionScreen) + (iTime * _TInfRotation * _TRotPower)), grabPos - 0.5);
							grabPos += 0.5;
						}
					}

					else if (grab2.y > _ScreenBounds.y || grab2.y < _ScreenBounds.x || grab2.x > _ScreenBounds.y || grab2.x < _ScreenBounds.x) { // front screen
						_TFRScreenZoom = 2.0 - 2.0 / (_TFRScreenZoom + 1.0);
						grabPos = (grabPos - 0.5) / _TFRScreenZoom;
						grabPos += 0.5;
					}
				} 

				UNITY_BRANCH if (Glitch)
				{
					float2 uv = grabPos.xy - i.grabPosForward.xy;
					uv /= factor;
					uv.x *= _ScreenParams.x / _ScreenParams.y;
					uv += 1.0;
					//float2 uv = i.viewPos.xy / abs(i.viewPos.z);
					//float2 uv = cubeUV(i.worldRayDir);
					float2 block = floor(uv * _Glitch_BlockSize);
					float linePos = block.y;

					float time = floor(fmod(_Time.y * _Glitch_UPS, 600));
					float rand = hash11(time);
					float2 blockID = block + rand;
					float lineID = linePos + rand;

					const uint max_subdiv = 2;
					float blockSize = _Glitch_BlockSize;
					float lineSize = _Glitch_BlockSize;
					for (uint s = max_subdiv; s; s--)
					{
						float h = hash11s(lineID);
						if (h < _Glitch_Macroblock)
						{
							lineSize *= 2;
							lineID = floor(uv.y * lineSize) + rand + 0.01;
							//lineID += h * linePos;
						}
					}

					for (s = max_subdiv; s; s--)
					{
						float2 h = hash22s(blockID);
						if (h.x < _Glitch_Macroblock)
						{
							blockSize *= 2;
							blockID = floor(uv * blockSize) + rand + 0.01;
							//blockID += h * block;
						}
					}

					float4 line_noise0 = hash41(lineID);
					float4 line_noise1 = hash41(lineID + 1);
					float4 line_noise2 = hash41(lineID + 2);
					float4 block_noise0 = hash42(blockID);
					float4 block_noise1 = hash42(blockID + 1);
					float4 block_noise2 = hash42(blockID + 2);

					_Glitch_ActiveTime = max(0.0001, _Glitch_ActiveTime);
					float glitchMul = pow(abs(sin(_Time.y * UNITY_PI / _Glitch_PeriodTime)), 1.0 / _Glitch_ActiveTime - 1.0);
					float block_thresh = _Glitch_Blocks * glitchMul;
					float line_thresh = _Glitch_Lines * glitchMul;
					line_thresh *= line_thresh;
					
					_Glitch_Intensity *= i.falloff;
					_Glitch_Displace *= _Glitch_Intensity;	
					_Glitch_Pixelization *= _Glitch_Intensity;
					_Glitch_Shift *= _Glitch_Intensity;
					_Glitch_Grayscale *= _Glitch_Intensity;
					_Glitch_ColorShift *= _Glitch_Intensity;
					_Glitch_Interleave *= _Glitch_Intensity;
					_Glitch_BrokenBlock *= _Glitch_Intensity;
					_Glitch_Posterization *= _Glitch_Intensity;
					
					// Displace
					if (line_noise0.x < line_thresh * _Glitch_Displace_Chance)
					{
						uv.x += (line_noise0.y - 0.5) * _Glitch_Displace;
					}
					else if (block_noise0.x < block_thresh * _Glitch_Displace_Chance)
					{
						uv.xy += (block_noise0.yz - 0.5) * _Glitch_Displace;
					}

					// Pixelization
					if (line_noise1.z < line_thresh * _Glitch_Pixelization_Chance)
					{
						float2 size = exp2(floor(8 - line_noise1.w *  _Glitch_Pixelization * 8));
						uv = (round(uv * lineSize * size + 0.5) - 0.5) / size / lineSize;
					}
					else if (block_noise1.z < block_thresh * _Glitch_Pixelization_Chance)
					{
						float2 size = exp2(floor(8 - block_noise1.w *  _Glitch_Pixelization * 8));
						uv = (round(uv * blockSize * size + 0.5) - 0.5) / size / blockSize;
					}

					// Shift
					if (line_noise0.y < line_thresh * _Glitch_Shift_Chance)
					{
						uv.x += (uv.y - (linePos + 1.0) / lineSize) * (line_noise0.w * 2 - 1) * _Glitch_Shift * lineSize;
					}

					// Grayscale
					if (line_noise0.z < line_thresh * _Glitch_Grayscale_Chance || block_noise0.z < block_thresh * _Glitch_Grayscale_Chance)
					{
						Color_Tint = 1;
						_Grayscale = line_noise0.w * _Glitch_Grayscale;
					}

					// Color Shift
					if (line_noise0.w < line_thresh * _Glitch_ColorShift_Chance)
					{
						grabPosOffsetR.x = (line_noise1.x * 3 - 1.5) * _Glitch_ColorShift * 0.5 * factor;
						grabPosOffsetB.x = (line_noise1.y * 3 - 1.5) * _Glitch_ColorShift * 0.5 * factor;
					}
					else if (block_noise0.w < block_thresh * _Glitch_ColorShift_Chance)
					{
						grabPosOffsetR.xy = (block_noise1.xy - 0.5) * _Glitch_ColorShift * 0.5 * factor;
						grabPosOffsetB.xy = (block_noise1.zw - 0.5) * _Glitch_ColorShift * 0.5 * factor;
					}

					// Interleave
					if (line_noise1.x < line_thresh * _Glitch_Interleave_Chance || block_noise1.x < block_thresh * _Glitch_Interleave_Chance)
					{
						Color_Tint = 1;

						float _line = frac(i.pos.y / 3.0);
						float3 mask;
						if (_line > 2.0 / 3.0)
							mask = float3(0, 0, 3);
						else if (_line > 1.0 / 3.0)
							mask = float3(0, 3, 0);
						else
							mask = float3(3, 0, 0);
						_Brightness *= lerp(1, mask, sqrt(_Glitch_Interleave));
					}
					
					//BrokenBlock
					if (line_noise1.y < line_thresh * _Glitch_BrokenBlock_Chance)
					{
						Color_Tint = 1;
						_Brightness = step(_Glitch_BrokenBlock, line_noise2.xyz);
					}
					else if (block_noise1.y < block_thresh * _Glitch_BrokenBlock_Chance)
					{
						Color_Tint = 1;
						_Brightness = step(_Glitch_BrokenBlock, block_noise2.xyz);
					}

					// Posterization
					if (line_noise1.w < line_thresh * _Glitch_Posterization_Chance)
					{
						Posterization = 1;
						_PosterizationSteps = (1 - _Glitch_Posterization) * lerp(32, 255, line_noise2.x) + 1;
					}
					else if (block_noise1.w < block_thresh * _Glitch_Posterization_Chance)
					{
						Posterization = 1;
						_PosterizationSteps = (1 -_Glitch_Posterization) * lerp(32, 255, block_noise2.x) + 1;
					}
					uv -= 1.0;
					uv.x /= _ScreenParams.x / _ScreenParams.y;
					uv *= factor;
					grabPos.xy = uv + i.grabPosForward.xy;
				}
				UNITY_BRANCH if (_SizeGirls)
				{
					//Girlscam https://www.shadertoy.com/view/4tVcRW
					float scanLineJitter = _SizeGirls * lerp(abs(_SinTime.w), 1.0, sin(_TimeGirls));
					float sl_thresh = saturate(1.0 - scanLineJitter * 1.2);
					float sl_disp = 0.002 + pow(scanLineJitter, 3.0) * 0.05;
					float jitter = hash12s(float2(round(grabPos.y * _LoonaIsHot_TexelSize.w) * _LoonaIsHot_TexelSize.y, _SinTime.w)) * 2.0 - 1.0;
					jitter *= step(sl_thresh, abs(jitter)) * sl_disp;
					grabPos.x += jitter * i.falloff * factor.x;
				}

				

				UNITY_BRANCH if(Magnification == MAGNIFICATION_GRAVITATIONAL_LENS) 
				{
					float magFalloff = dot(i.viewCenter, i.viewCenter);
					magFalloff = 1.0 / (1.0/ _Gravitation*magFalloff + 1.0);

					i.viewCenter = normalize(i.viewCenter);
					float angle = acos(dot(i.viewPos, i.viewCenter)) / UNITY_PI;
					float3 viewPos = i.viewPos * 0.5;
					
					float angleFalloff = smoothstep(0, 1, (angle - _MaxAngle) / (_AngleStartFade - _MaxAngle));
				
					float3 vec = i.viewCenter - viewPos;
					float3 viewSpaceDistorsion = viewPos + vec * magFalloff * angleFalloff * i.falloff * tan(_Magnification * UNITY_HALF_PI);
					float4 grabPosDest = ComputeGrabScreenPos(UnityViewToClipPos(viewPos));
					float4 grabPosSrc = ComputeGrabScreenPos(UnityViewToClipPos(viewSpaceDistorsion));
					float4 magOffset = grabPosSrc / grabPosSrc.w - grabPosDest / grabPosDest.w;
					grabPos.xy += magOffset.xy;
				}
		
				UNITY_BRANCH if(Pixelization)
				{
					float2 blockSize = _ScreenParams.xy / factor / lerp(1.0, float2(_PSize_X, _PSize_Y), i.falloff);
					grabPos.xy = round(grabPos.xy * blockSize) / blockSize;
				}

				UNITY_BRANCH if (_UseFrost) {
					float seed = _FrostSeed * iTime * _FrostSpeed;
					float randomDistortion1 = random(i.viewPos.xy, seed);
					float randomDistortion2 = random(i.viewPos.xy, seed + 1.0);
					float randomDistortion3 = random(i.viewPos.xy, seed + 2.0);

					// Distortion calculations
					float2 distortion = float2(
						sin((i.viewPos.x + randomDistortion1) * _FrostPower / 10),
						sin((i.viewPos.y + randomDistortion2) * _FrostPower / 10)
					);

					grabPos.xy += distortion;
				}

				float4 maskColor = 1.0;
				float maskGray = 1.0;
				
				
				
				UNITY_BRANCH if(Distorsion)
				{
					float3 displace = DistorsionSampleDir(i.worldRayDir);

					displace.x *= _ScreenParams.y / _ScreenParams.x;
					grabPos.xy += displace.xy * i.falloff * factor * maskGray;
					//grabPos.xy += DistorsionSample(vr_uv + 0.5) * i.falloff * factor * maskGray;
				}

				UNITY_BRANCH if (_USEUVDUPE) {
					float2 uvDupe = UVDupe(grabPos);
					grabPos = lerp(grabPos, uvDupe, _DupeDist);
				}

				UNITY_BRANCH if (_USEFRACTLINES) {
					float2 fractLines = FractLines(grabPos);
					grabPos = lerp(grabPos, fractLines, _FractLinesOrgin);
				}

				UNITY_BRANCH if (_USEZOOMLOOP) {
					float2 zoomLoop = ZoomLoop(grabPos);
					grabPos = lerp(grabPos, zoomLoop, _LoopAlpha);
				}

				UNITY_BRANCH if (_USEDSUV) {
					float2 dsUV = DSNorm(grabPos, 1);
					grabPos = lerp(grabPos, dsUV, _DSUVOrgin);
				}

				UNITY_BRANCH if (_UseWaves) {
					float time = iTime * _WavesSpeed;
					if(_WaveAxis == 0) {
						grabPos += _WavesPower * cos(_WavesStrength * grabPos.x + time);  // x
					} else if(_WaveAxis == 1) {
						grabPos += _WavesPower * cos(_WavesStrength * grabPos.y + time);  // y
					} else if(_WaveAxis == 2) {
						grabPos += _WavesPower * cos(_WavesStrength * grabPos.xy + time); // xy
					}
					
					
				}

				UNITY_BRANCH if (_UseFlag) {
					float time = iTime * _FlagSpeed + _FlagOffset;
					float flag;
					

					if (_FlagAxis == 0) {
						flag = lerp(1., _FlagStrength, smoothstep(-_FlagPower, _FlagPower, -cos(time-_FlagAmount*(grabPos.x))));
					
					} else if (_FlagAxis == 1) {
						flag = lerp(1., _FlagStrength, smoothstep(-_FlagPower, _FlagPower, -cos(time-_FlagAmount*(grabPos.y))));
					}
					grabPos /= flag;
				}
				
				
				UNITY_BRANCH if (_UseCSplit) {
					float2 uv = grabPos;
					
					float2 centerCoord = float2(0.5, 0.5) / _ScreenParams.xy;
					float dist = max(1.0, _ScreenParams.y - distance((i.grabPos.xy/i.grabPos.w), centerCoord + 0.5));
					
					float rotation = round(dist * _CSplitIter);
					float2 CSstrength = float2(_CSplitStrength,_CSplitStrength);
					float strength = distance(centerCoord, float2(CSstrength)) * (1.0 / _ScreenParams.x);
					
					float2 ruv = SplitRot(uv, rotation * strength, float2(0.5, 0.5));
					grabPos = lerp(grabPos, ruv, _CSplitPower * i.falloff);
					
				}

				if (_UseTanTransition) {
					float2 tanUv = grabPos - 0.5;
					tanUv.x/=0.5;
					float2 vigUV = grabPos;
					float2x2 Matrix = TanTransitionMatrix(tanUv);
					tanUv.x*=0.5;
					tanUv = lerp(tanUv, mul(Matrix, tanUv), _TanTransitionPower);
					tanUv *= _TanTransitionZoom;
					tanUv += 0.5;
					//tanUv = frac(tanUv);
					grabPos = lerp(grabPos, tanUv, _UseTanTransition * i.falloff );
				}
				
				UNITY_BRANCH if (_UseRotation == 0) {
					grabPos = grabPos;
				}
				else if (_UseRotation == 1) {
					float2 uv = grabPos - 0.5;
					float2 ruv = mul(r2d(((_RotationStrength / 2.) + iTime * (_RotationSpeed * 10.))), uv);
					grabPos = lerp(grabPos, ruv + 0.5, _RotationPower * i.falloff);
				}

				UNITY_BRANCH if (_Use3DRot)
				{
			
					grabPos -= _rotcent;
					float rx = radians(_Xrange * sin(_Time.y * _XSpeed) + (1.0 * _XManual)); 
					float ry = radians(_Yrange * sin(_Time.y * _YSpeed) + (1.0 * _YManual));
					float rz = radians(_Zrange * sin(_Time.y * _ZSpeed) + _ZManual);
					float s,c;
					sincos(rz,s,c);
					float2x2 rotationMatrix = float2x2(c, s, -s, c);
					float3 rotuv = float3(grabPos - 0.5, 1);

					float3 rv = float3(0, 0, 1);
					rotuv.x *= asp; rv.x *= asp; 	
					rotuv = mul(rot3D(+rx, +ry, 0), rotuv); rv = mul(rot3D(-rx, -ry, 0), rv); rotuv.xy = mul(rotationMatrix, rotuv);
					rotuv.x /= asp; rv.x /= asp;
					grabPos = (rv + rotuv * rv.z / rotuv.z).xy + 0.5 + _rotcent;
				}

				half4 color = SampleGrabTexture(grabPos); ///////////////////

				UNITY_BRANCH if (Glitch)
				{
					color.r = SampleGrabTexture(grabPos + grabPosOffsetR).r;
					color.b = SampleGrabTexture(grabPos + grabPosOffsetB).b;
				}
				
				UNITY_BRANCH if(Blur)
				{
					float2 blurVector;
					float3 blurColor = 0;
					float blurStep = 1.0 / _BlurIterations;
					float dithering = blurStep * _Blur_Dithering * (fmod(i.pos.x + i.pos.y * 2, 4) / 4 - 0.5);
					//float dithering = blurStep * hash12(i.pos.xy);
					[forcecase] switch (Blur)
					{
						case BLUR_HORIZONTAL:
						{
							sincos((_BlurRotation + _Time.y * _BlurRotationSpeed) * UNITY_HALF_PI, blurVector.y, blurVector.x);
							blurVector.y *= _ScreenParams.x / _ScreenParams.y;
							blurVector *= _BlurRange;
							//blurVector += BlurDistorsion(vr_uv);
							UNITY_BRANCH if (Blur_Distorsion)
								blurVector += DistorsionSampleDir(i.worldRayDir).xy;
							blurVector *= i.falloff * factor;

							for (float x = -0.5; x <= 0.5; x += blurStep)
								blurColor += SampleGrabTexture(grabPos.xy + (x + dithering) * blurVector);
							break;
						}
						case BLUR_STAR:
						{
							sincos((_BlurRotation + _Time.y * _BlurRotationSpeed) * UNITY_HALF_PI, blurVector.y, blurVector.x);
							blurVector.y *= _ScreenParams.x / _ScreenParams.y;
							blurVector *= _BlurRange;
							//blurVector += BlurDistorsion(vr_uv);
							UNITY_BRANCH if (Blur_Distorsion)
								blurVector += DistorsionSampleDir(i.worldRayDir).xy;
							blurVector *= i.falloff * factor;

							for (float x = -0.5; x <= 0.5; x += blurStep)
								blurColor += SampleGrabTexture(grabPos.xy + (x + dithering) * blurVector);
							sincos((_BlurRotation + 1 + _Time.y * _BlurRotationSpeed) * UNITY_HALF_PI, blurVector.y, blurVector.x);
							blurVector.y *= _ScreenParams.x / _ScreenParams.y;
							blurVector *= _BlurRange;
							//blurVector += BlurDistorsion(vr_uv);
							UNITY_BRANCH if (Blur_Distorsion)
								blurVector += DistorsionSampleDir(i.worldRayDir).xy;
							blurVector *= i.falloff * factor;
							for (x = -0.5; x <= 0.5; x += blurStep)
								blurColor += SampleGrabTexture(grabPos.xy + (x + dithering) * blurVector);
							blurColor *= 0.5;
							break;
						}
						case BLUR_CIRCLE:
						{
							float rotation = (_BlurRotation + _Time.y * _BlurRotationSpeed) * UNITY_HALF_PI;
							float2 vecMul = _BlurRange;
							vecMul.y *= _ScreenParams.x / _ScreenParams.y;
							//vecMul += BlurDistorsion(vr_uv);
							UNITY_BRANCH if (Blur_Distorsion)
								vecMul += DistorsionSampleDir(i.worldRayDir).xy;
							vecMul *= i.falloff * factor;
							for (float x = 0.0; x <= 1.0; x += blurStep)
							{
								sincos(rotation + (x + dithering) * UNITY_TWO_PI, blurVector.y, blurVector.x);
								blurVector *= vecMul;
								blurColor += SampleGrabTexture(grabPos.xy + blurVector);
							}
							break;
						}
						case BLUR_RADIAL:
						{
							blurVector = -(vr_uv + _BlurCenterOffset.xy);
							float2 rotatedBlurVec = float2(blurVector.y, -blurVector.x);
							float2 sc;
							sincos((_BlurRotation + _Time.y * _BlurRotationSpeed) * UNITY_HALF_PI, sc.y, sc.x);
							blurVector = blurVector * sc.x + rotatedBlurVec * sc.y;
							blurVector.y *= _ScreenParams.x / _ScreenParams.y;
							blurVector *= _BlurRange;
							//blurVector += BlurDistorsion(vr_uv);
							UNITY_BRANCH if (Blur_Distorsion)
								blurVector += DistorsionSampleDir(i.worldRayDir).xy;
							blurVector *= i.falloff * factor;

							for (float x = -0.5; x <= 0.5; x += blurStep)
								blurColor += SampleGrabTexture(grabPos.xy + (x + dithering) * blurVector);
							break;
						}
					}
					blurColor /= floor(_BlurIterations + 1.0);
					color.rgb = lerp(color.rgb, blurColor.rgb, _BlurColor * lerp(1.0, maskGray, _BlurMask));
				}
				UNITY_BRANCH if(Chromatic_Aberration)
				{
					float shift = 0.5 + 0.5*cos(_Time.y*_CA_speed);
					shift = _CA_amplitude * pow(shift, 3.0) * i.falloff;
					float2 shift2;
					if(Chromatic_Aberration >= CHROMATIC_ABERRATION_RADIAL)
					{
						#ifdef UNITY_SINGLE_PASS_STEREO
							shift2 = vr_uv + _CA_centerOffset.xy;
						#else
							shift2 = vr_uv * _ScreenParams.yy / _ScreenParams.xy + _CA_centerOffset.xy;
						#endif
					
						float l = length(shift2);
						shift2 *= -shift*l;
					}
					else
					{
						sincos((_CARotation + _Time.y * _CARotationSpeed) * UNITY_HALF_PI, _CA_direction.y, _CA_direction.x);
						shift2 = _CA_direction.xy * shift;
						
						shift2.y *= _ScreenParams.x / _ScreenParams.y;
					}
					shift2 *= factor;
					float3 chromatcColor = 0;
				
					UNITY_BRANCH if(Aberration_Quality >= ABERRATION_QUALITY_MULTISAMPLING)
					{
						float w = 1.0 / _CA_iterations;
						//float dithering = w * (hash12(i.pos.xy) - 0.5);
						float dithering = w * _CA_dithering * (fmod(i.pos.x + i.pos.y * 2, 4) / 4 - 0.5);
						UNITY_BRANCH if(CA_Distorsion)
							shift2 += DistorsionSampleDir(i.worldRayDir).xy * i.falloff;
						UNITY_BRANCH if(Chromatic_Aberration <= CHROMATIC_ABERRATION_VECTOR)
							UNITY_LOOP for(float t = 0.0; t < 1.0; t += w)
							{
								float2 uv = (t - 0.5 + dithering) * shift2;
								chromatcColor += rainbow(t) * SampleGrabTexture(grabPos.xy + uv).rgb;
							}
						else
							UNITY_LOOP for(float x = 0.0; x < 1.0 ; x += w)
							{
								float2 uv = (x + dithering) * shift2;
								chromatcColor += rainbow(x) * SampleGrabTexture(grabPos.xy + uv).rgb;
							}
						chromatcColor /= _CA_iterations;
						color.rgb = lerp(color.rgb, chromatcColor, _CA_factor * lerp(1.0, maskColor.rgb, _CA_mask));
					}
					else
					{
						UNITY_BRANCH if(CA_Distorsion)
							shift2 += DistorsionSampleDir(i.worldRayDir).xy * i.falloff;
						color.r = lerp(color.r, SampleGrabTexture(grabPos - shift2).r, _CA_factor* lerp(1.0, maskColor.r, _CA_mask));
						color.b = lerp(color.b, SampleGrabTexture(grabPos + shift2).b, _CA_factor* lerp(1.0, maskColor.b, _CA_mask));
					}
				}

				UNITY_BRANCH if (HorrorSpiral) {
					float4 Horror = CreateHorrorSpiral(grabPos);
					float v = calcVignette(vigUV, _HorrorVignette);
					color = lerp(color, Horror, _HAlphaSpiral) * v;
				}

				UNITY_BRANCH if (SurfaceOfTheVoid) {
					float4 Void = CreateVoid(grabPos);
					float v = calcVignette(vigUV, _SurfVignette);
					color = lerp(color, Void, _VuvPower) * v;
				}

				UNITY_BRANCH if (_VoxelTunnelToggle) {
					float4 Voxel = CreateVoxel(grabPos);
        			float v = calcVignette(vigUV, _VoxelVignette);
					color = lerp(color, Voxel, _VoxelAlpha) * v;
				}

				UNITY_BRANCH if (_NSpriToggle) {
					float4 nspri = CreateNextrixSpiral(grabPos);
					float v = calcVignette(vigUV, _NSpriVignette);
					color = lerp(color, nspri, _NSpriAlpha) * v;
				}

				UNITY_BRANCH if (_Acid) {
					float2 uv = grabPos;
					float4 acid = float4(color);
					acid = mod(acid + ACIDTIME, 4.0);
					acid = floor(acid*_AcidIter);
					acid = mod(acid,2.);
					color.rgb = lerp(color.rgb, acid.rgb * ACIDCOLOR.rgb, _AcidPower * _AcidAlpha);
				}

				UNITY_BRANCH if (_UseScanlines) {
					float scanlines = frac(mul(r2d(_ScanlinesRot / 1.),grabPos.xy) * floor(-_ScanLinesIter) + iTime * _ScanlinesSpeed);
					color.rgb = lerp(color.rgb, float(scanlines) * _ScanlinesColor.rgb, _ScanlinesPower);
				}

				UNITY_BRANCH if (_UseUVDither) {
					float2 scaledUV = fract(grabPos) * _DitherScale;
					float center = saturate(length(grabPos - 0.5) - lerp(-1,2,_DitherCenter));
					fixed ditherMatrix[4][4] = {
						{ 0.0625, 0.5625, 0.1875, 0.6875 },
						{ 0.8125, 0.3125, 1.0000, 0.5000 },
						{ 0.2500, 0.7500, 0.1250, 0.6250 },
						{ 1.0000, 0.5000, 0.8750, 0.3750 }
					};

					int x = (uint)(scaledUV.x * 4) % 4;
					int y = (uint)(scaledUV.y * 4) % 4;
					half ditherValue = ditherMatrix[y][x];

					half strength = _DitherPower;
					half ditherThreshold = 1.0 - strength;
					
					float3 ditherFinal = (((ditherValue) - ditherThreshold)) * _DitherColor.rgb;
					color.rgb += lerp(color.rgb + ditherFinal.rgb, _DitherColor.rgb, _DitherColor.a) * center * strength;
					//color.rgb += ditherFinal.rgb * center * strength;
				}

				UNITY_BRANCH if (_UsePixelSort) {
						// Pixel Sorting
						float2 newGrab = grabPos;
						float sortThreshold = 1.0 - clamp(_PixelsortPower / 2.6, 0.0, 1.0);
						float2 sortUv = float2(newGrab.y, sortThreshold);

						if (_SortAxis == 0) {
							sortUv = float2(grabPos.x, sortThreshold);
						} else {
							sortUv = float2(grabPos.y, sortThreshold);
						}
						sortUv = float2(newGrab.x, sortThreshold);
						newGrab.y += pow(_PixelsortPower, 2 + (_PixelsortPower * 2)) * newGrab.x * frac(sin(dot(float(newGrab.x), float2(_PixelsortRotation, _PixelsortRotation)))* _PixelsortIterations);
						// Curved melting transition
						if (_SortAxis == 0) {
							newGrab.y += pow(_PixelsortPower, 2 + (_PixelsortPower * 2)) * newGrab.x * frac(sin(dot(float(newGrab.x), float2(_PixelsortRotation, _PixelsortRotation)))* _PixelsortIterations);
						} else {
							newGrab.x += pow(_PixelsortPower, 2 + (_PixelsortPower * 2)) * newGrab.y * frac(sin(dot(float(newGrab.y), float2(12.9, 78.2)))* _PixelsortIterations);
						}
						
						//grabPos = lerp(grabPos, sortUv * grabPos, _PixelsortUV);

						// Draw pixel sorting effect behind the melting transition
						if (newGrab.y > 1.) {
							color.rgb = lerp(color.rgb, SampleGrabTexture(sortUv), _PixelsortUV);
						} else {
							color.rgb = lerp(color.rgb, SampleGrabTexture(newGrab), _PixelsortUV);
						}
					}

				UNITY_BRANCH if(_UseOutline) {

					//float2 outUV = (i.viewPos.xy) - 0.5;

					outUV -= 0.5;
					outUV /= 2.0 - 2.0 / (_OZoom + 1.0);
					outUV += 0.5;

					outUV += _OMovement.xy;

					UNITY_BRANCH if (_UseODistortion) {
						float2 ODist = DSNorm(outUV, 3);
						outUV = lerp(outUV, ODist, _ODistOrigin);
					}

					UNITY_BRANCH if (_UseOShake) {
						float2 shake = float2(0.0, 0.0);
						shake.x = sin(iTime * (_OShakeFreqX * 1.5)) * (_OShakeAmpX * 0.01);
						shake.y = cos(iTime * (_OShakeFreqY * 1.5)) * (_OShakeAmpY * 0.01);

						outUV = lerp(outUV, shake+outUV, _OShakePower);
					}

					UNITY_BRANCH if (_ORenderMode == 0) {
						outUV = outUV;
					} 
					UNITY_BRANCH if (_ORenderMode == 1) {
						outUV = fract(outUV);
					} 
					UNITY_BRANCH if (_ORenderMode == 2) {
						outUV = saturate(outUV);
					} 

					

					float outline = makeSobelEdge(outUV, _OutlineTolerance, _OutlineSize, float2(0, 0), _LoonaIsHot);
					
					UNITY_BRANCH if (_ORenderMode == 3 || _ORenderMode == 4) {
						if( outUV.y < 0. || outUV.y > 1. || outUV.x < 0. || outUV.x > 1.) {
							outline *= 0;
						}
					}
					
					color.rgb = lerp(color.rgb, _OutlineColor.rgb, outline * _OutlinePower * i.falloff); 
				}

				UNITY_BRANCH if(Neon)
				{
					float3 pix = float3(_LoonaIsHot_TexelSize.xy, 0) * _NeonWidth * factor.x;
					float3 color_sub = SampleGrabTexture(grabPos.xy - pix.xz);
					color_sub += SampleGrabTexture(grabPos.xy + pix.xz);
					color_sub += SampleGrabTexture(grabPos.xy - pix.zy);
					color_sub += SampleGrabTexture(grabPos.xy + pix.zy);
					float3 delta_color = 4.0*color.rgb*_NeonOrigColorAlpha - color_sub;
					delta_color *= _NeonBrightness;
					delta_color = lerp(delta_color, length(delta_color) > 1.0 ? normalize(delta_color) : 0.0, _NeonPosterization);
					delta_color = lerp(delta_color, abs(delta_color), _NeonGlow);
					float3 neonColor = color.rgb * _NeonOrigColor.rgb + delta_color *_NeonColor.rgb;
					color.rgb = lerp(color.rgb, neonColor, _NeonColorAlpha * i.falloff);
				}
				float3 hsv;
				float hsvMask;
				UNITY_BRANCH if (HSV_Selection || HSV_Transform)
					hsv = RGBToHSV(color.rgb);
				else
					hsv = 0.0;
				UNITY_BRANCH if (HSV_Selection)
				{
					float3 targetHSV = RGBToHSV(_TargetColor.rgb);
					float3 diff;
					diff.x = frac(targetHSV.x - hsv.x);
					diff.x -= step(0.5, diff.x);
					diff.yz = targetHSV.yz - hsv.yz;

					hsvMask = abs(diff.x) < _HueRange ? 1 : 1 - saturate((abs(diff.x) - _HueRange) / _HueSmoothRange - 1);
					hsvMask *= diff.y < _SaturationRange ? 1 : 1 - saturate(max(0, diff.y - _SaturationRange) / _SaturationSmoothRange - 1);
					hsvMask *= diff.z < _LightnessRange ? 1 : 1 - saturate(max(0, diff.z - _LightnessRange) / _LightnessSmoothRange - 1);

					if (HSV_Desaturate_Selected)
						hsv.y = hsv.y * hsvMask;
					if (HSV_Transform == 0)
						color.rgb = lerp(color.rgb, HSVToRGB(hsv), i.falloff);
				}
				else
					hsvMask = 1.0;

				UNITY_BRANCH if(HSV_Transform)
				{
					float3 transformHSV = RGBToHSV(_TransformColor.rgb);
					transformHSV.x = frac(transformHSV.x + _Time.y * _HueAnimationSpeed);
					if (_Hue < 1.0)
					{
						float hue_diff = frac(transformHSV.x - hsv.x);
						hue_diff -= step(0.5, hue_diff);
						float hue_shift = -8.0*hue_diff*(hue_diff*hue_diff - 0.25); //Smoothing hue shift
						hsv.x = frac(hsv.x + hue_shift * _Hue);
					}
					else
						hsv.x = transformHSV.x;
					hsv.y = lerp(hsv.y, transformHSV.y, _Saturation);
					hsv.z = lerp(hsv.z, transformHSV.z, _Lightness);
					color.rgb = lerp(color.rgb, HSVToRGB(hsv), i.falloff * hsvMask);
				}

				UNITY_BRANCH if(Color_Tint)
				{
					float3 col = color;
					if(ACES_Tonemapping)
						col = ACESFilm(max(0, col));
					col = lerp(col, 1 - min(1, col), float3(_RedInvert, _GreenInvert, _BlueInvert));
					col = max(0.0, (col - 0.5)*_Contrast + 0.5);
					col = pow(col, _Gamma);
					col *= _Brightness;
					col = lerp(col, LinearRgbToLuminance(col), _Grayscale);
					col = lerp(col, _Color, _ColorAlpha);
					col += _EmissionColor.rgb;
					color.rgb = lerp(color.rgb, col, i.falloff);
				}

				UNITY_BRANCH if(Posterization)
				{
					float luminance = max(0.001, LinearRgbToLuminance(color.rgb));
					color.rgb = lerp(color.rgb, color.rgb / luminance * round( luminance * _PosterizationSteps ) / _PosterizationSteps, i.falloff);
				}
				
				UNITY_BRANCH if (Static_Noise)
				{
					//float staticValue = hash13(float3(grabPos.xy, _Time.x));
					//staticValue *= staticValue <= _StaticIntensity ? _StaticBrightness / _StaticIntensity : 0.0;
					//float3 staticColor = lerp(color.rgb, _StaticColor.rgb, saturate(staticValue + _StaticAlpha - 1));

					float staticValue = hash13s(float3(grabPos.xy, _Time.x)) * tan(_StaticIntensity * UNITY_HALF_PI);
					float3 staticColor = staticValue * _StaticColor.rgb * lerp(color.rgb, 1.0, _StaticAlpha);
					color.rgb = lerp(color.rgb, staticColor + color.rgb * _StaticBrightness, i.falloff);
				}
				UNITY_BRANCH if(Vignette)
				{
					float2 VignetteUV = vr_uv;
					if (_VignetteShape < 0)
						VignetteUV.y *= 1.0 + _VignetteShape;
					else
						VignetteUV.x *= 1.0 - _VignetteShape;

					_VignetteRounding = max(0.05, _VignetteRounding);
					float z = pow(dot(1.0, pow(abs(VignetteUV), 2.0 / _VignetteRounding)), _VignetteRounding / 2.0);
					float vignette = saturate(pow(saturate(z + _VignetteWidth), 1.0 / tan(_VignetteAlpha * UNITY_HALF_PI)));

					color.rgb = lerp(color.rgb, _VignetteColor, vignette * i.falloff);
					
					//The best formula for desktop (but not for VR) from https://www.shadertoy.com/view/lsKSWR
					//float2 windowPos = VignetteUV;
					//windowPos *= 1.0 - windowPos.yx;
					//float vignette = windowPos.x * windowPos.y * (1.0 - _VignetteAlpha) * 100.0;
					//color.rgb = lerp(color.rgb, _VignetteColor, saturate(1.0 - pow(vignette, _VignetteWidth)) * i.falloff);
				}

				UNITY_BRANCH if (_UsingParticles) {
					float4 SPart = ScreenParticles(float4(color), grabPos.xy - 0.5);
					color.rgb += SPart.rgb * _PartBGAlpha;
				}
				UNITY_BRANCH if(BarsToggle) 
				{
					float2 uv = grabPos; 
					float2 cosDistort = grabPos;
					float2 circDistort = grabPos;
					
					float4 SquareNorm;
					float4 TriangleNorm;

					float4 SquareCos = float(createSquare(cosDistort));  // square
					float4 TriangleCos = float(createTriangle(cosDistort));  // strongest shape

					float4 SquareCircle = float(createSquare(circDistort));  // square
					float4 TriangleCircle = float(createTriangle(circDistort));  // strongest shape

					uv.xy = mul(uv, r2d(_barsRotate));
					cosDistort.xy = mul(cosDistort, r2d(_barsRotate)); 

					uv -= 0.5;
					uv *= _zoomOutBars;
					uv += 0.5;
					uv.xy = uv.xy * _XYScaleBars;
					uv.xy = uv.xy + _XYMoveBars;
					
					float4 barsxy = float4(_Bottom * _PowerAll + 0.0,  1-_Top * _PowerAll,
											_Left * _PowerAll - 0.1,  1.2 - _Right * _PowerAll - 0.1);

					float4 HueWaveNorm, HueWaveCos, HueWaveCirc;
					

					if (_UseOutlineHue == 1) {
						HueWaveNorm = hueWave(uv);
						HueWaveCos = hueWave(cosDistort);
						HueWaveCirc = hueWave(circDistort);
					} else if (_UseOutlineHue == 2) {
						HueWaveNorm = hueCircle(uv);
						HueWaveCos = hueCircle(cosDistort);
						HueWaveCirc = hueCircle(circDistort);
					} else if (_UseOutlineHue == 0) {
						HueWaveNorm = _outlineColor;
						HueWaveCos = _outlineColor;
						HueWaveCirc = _outlineColor;
					}

					if(_DistortType == 0) {   // Normal Distort

						float2 normDistort = DSNorm(uv, 0);

						if (_GridDistort == 1) {
							SquareNorm = float(createSquare(normDistort));  // square
							TriangleNorm = float(createTriangle(normDistort));  // strongest shape
						} else {
							SquareNorm = float(createSquare(uv));  // square
							TriangleNorm = float(createTriangle(uv));  // strongest shape
						}

						if(_GridType == 0) {
							if( normDistort.y < barsxy.x + _outlineOffset || normDistort.y > barsxy.y - _outlineOffset || normDistort.x < barsxy.z + _outlineOffset || normDistort.x > barsxy.w - _outlineOffset ) {
								color = float4(HueWaveNorm.rgb, _barsColor.a);  // outline
								float Shift = _outlineShift/normDistort;
								color.rgb += Shift + HueWaveNorm.rgba;
							}
							if( normDistort.y < barsxy.x || normDistort.y > barsxy.y || normDistort.x < barsxy.z || normDistort.x > barsxy.w ) {
								color = float4(_barsColor.rgb, _barsColor.a);  // normal
								
							}
							
						} else if (_GridType == 1) {
							if( normDistort.y < barsxy.x + _outlineOffset || normDistort.y > barsxy.y - _outlineOffset || normDistort.x < barsxy.z + _outlineOffset || normDistort.x > barsxy.w - _outlineOffset ) {
								color = float4(SquareNorm.rgb * HueWaveNorm.rgb, SquareNorm.a * _outlineColor.a);  // outline
								float Shift = _outlineShift/normDistort;
								color.rgba += Shift + HueWaveNorm.rgba;
							}
							if( normDistort.y < barsxy.x || normDistort.y > barsxy.y || normDistort.x < barsxy.z || normDistort.x > barsxy.w ) {
								color = float4(SquareNorm.rgb * _barsColor.rgb,  _barsColor.a * SquareNorm.a);  // square
							}
						} else if (_GridType == 2) {
							if( normDistort.y < barsxy.x + _outlineOffset || normDistort.y > barsxy.y - _outlineOffset || normDistort.x < barsxy.z + _outlineOffset || normDistort.x > barsxy.w - _outlineOffset ) {
								color = float4(TriangleNorm.rgb * HueWaveNorm.rgb, TriangleNorm.a * _outlineColor.a);  // outline
								float Shift = _outlineShift/normDistort;
								color.rgba += Shift + HueWaveNorm.rgba;
							}
							if( normDistort.y < barsxy.x || normDistort.y > barsxy.y || normDistort.x < barsxy.z || normDistort.x > barsxy.w ) {
								color = float4(TriangleNorm.rgb * _barsColor.rgb, TriangleNorm.a * _barsColor.a);  // triangle
							}
						}
					}
					else if (_DistortType == 1) {   // Cos Distort
						
						cosDistort = DSCos(uv);

						if (_GridDistort == 1) {
							SquareCos = float(createSquare(cosDistort));  // square
							TriangleCos = float(createTriangle(cosDistort));  // strongest shape
						} else {
							SquareCos = float(createSquare(i.uv.xy));  // square
							TriangleCos = float(createTriangle(i.uv.xy));  // strongest shape
						}

						if(_GridType == 0) {
							if( cosDistort.y < barsxy.x + _outlineOffset || cosDistort.y > barsxy.y - _outlineOffset || cosDistort.x < barsxy.z + _outlineOffset || cosDistort.x > barsxy.w - _outlineOffset ) {
								color = float4(HueWaveCos.rgb, _outlineColor.a);  // outline
								float Shift = _outlineShift/cosDistort;
								color.rgba += Shift + HueWaveCos.rgba;
							}
							if( cosDistort.y < barsxy.x || cosDistort.y > barsxy.y || cosDistort.x < barsxy.z || cosDistort.x > barsxy.w ) {
								color = float4(_barsColor.rgb, _barsColor.a);  // cosine
							}
						} else if (_GridType == 1) {
							if( cosDistort.y < barsxy.x + _outlineOffset || cosDistort.y > barsxy.y - _outlineOffset || cosDistort.x < barsxy.z + _outlineOffset || cosDistort.x > barsxy.w - _outlineOffset ) {
								color = float4(SquareCos.rgb * HueWaveCos.rgb, SquareCos.a * _outlineColor.a);  // outline
								float Shift = _outlineShift/cosDistort;
								color.rgba += Shift + HueWaveCos.rgba;
							}
							if( cosDistort.y < barsxy.x || cosDistort.y > barsxy.y || cosDistort.x < barsxy.z || cosDistort.x > barsxy.w ) {
								color = float4(SquareCos.rgb * _barsColor.rgb, SquareCos.a * _barsColor.a);  // square
							}
						} else if (_GridType == 2) {
							if( cosDistort.y < barsxy.x + _outlineOffset || cosDistort.y > barsxy.y - _outlineOffset || cosDistort.x < barsxy.z + _outlineOffset || cosDistort.x > barsxy.w - _outlineOffset ) {
								color = float4(TriangleCos.rgb * HueWaveCos.rgb, TriangleCos.a * _outlineColor.a);  // outline
								float Shift = _outlineShift/cosDistort;
								color.rgba += Shift + HueWaveCos.rgba;
							}
							if( cosDistort.y < barsxy.x || cosDistort.y > barsxy.y || cosDistort.x < barsxy.z || cosDistort.x > barsxy.w ) {
								color = float4(TriangleCos.rgb * _barsColor.rgb, TriangleCos.a * _barsColor.a);  // triangle
							}
						}
					}
					else if (_DistortType == 2) {
						circDistort = DSCircle(uv,0);

						if (_GridDistort == 1) {
							SquareCircle = float(createSquare(circDistort));  // square
							TriangleCircle = float(createTriangle(circDistort));  // strongest shape
						} else {
							SquareCircle = float(createSquare(i.uv.xy));  // square
							TriangleCircle = float(createTriangle(i.uv.xy));  // strongest shape
						}

						if(_GridType == 0) {
							if( circDistort.y < barsxy.x + _outlineOffset || circDistort.y > barsxy.y - _outlineOffset || circDistort.x < barsxy.z + _outlineOffset || circDistort.x > barsxy.w - _outlineOffset ) {
								color = float4(HueWaveCirc.rgb, _outlineColor.a);  // outline
								float Shift = _outlineShift/circDistort;
								color.rgba *= Shift + HueWaveCirc.rgba;
							}
							if( circDistort.y < barsxy.x || circDistort.y > barsxy.y || circDistort.x < barsxy.z || circDistort.x > barsxy.w ) {
								color = float4(_barsColor.rgb, _barsColor.a);  // circle
							}
						} else if (_GridType == 1) {
							if( circDistort.y < barsxy.x + _outlineOffset || circDistort.y > barsxy.y - _outlineOffset || circDistort.x < barsxy.z + _outlineOffset || circDistort.x > barsxy.w - _outlineOffset ) {
								color = float4(SquareCircle.rgb * HueWaveCirc.rgb, SquareCircle.a * _outlineColor.a);  // outline
								float Shift = _outlineShift/circDistort;
								color.rgba *= Shift + HueWaveCirc.rgba;
							}
							if( circDistort.y < barsxy.x || circDistort.y > barsxy.y || circDistort.x < barsxy.z || circDistort.x > barsxy.w ) {
								color = float4(SquareCircle.rgb * _barsColor.rgb, SquareCircle.a * _barsColor.a);  // square
							}
						} else if (_GridType == 2) {
							if( circDistort.y < barsxy.x + _outlineOffset || circDistort.y > barsxy.y - _outlineOffset || circDistort.x < barsxy.z + _outlineOffset || circDistort.x > barsxy.w - _outlineOffset ) {
								color = float4(TriangleCircle.rgb * HueWaveCirc.rgb, TriangleCircle.a * _outlineColor.a);  // outline
								float Shift = _outlineShift/circDistort;
								color.rgba *= Shift + HueWaveCirc.rgba;
							}
							if( circDistort.y < barsxy.x || circDistort.y > barsxy.y || circDistort.x < barsxy.z || circDistort.x > barsxy.w ) {
								color = float4(TriangleCircle.rgb * _barsColor.rgb, TriangleCircle.a * _barsColor.a);  // triangle
							}
						}
					}

					float vignette;
					float2 vigUV = (i.uv.xy / i.uv.w) - 0.5;
					vigUV.xy = vigUV.xy * _XYScaleVignette;
					vigUV.xy = vigUV.xy + _XYMoveVignette;

					if (_BarsVignette == 1) {
						vignette = smoothstep(length(vigUV), _vigAlpha, _vigPower);
					} else {
						vignette = 1;
						_vigAlpha = 0;
					}
					
					color.rgb = lerp(color.rgb, _barsColor.rgb, 0);

				
			
					color = color * vignette;

				}
				
				UNITY_BRANCH if (_ToggleReel) {
					float3 insideColor = _ReelInsideColor;
					float2 uv = mul(grabPos - 0.5, r2d(_ReelRot));
					float2 correctPos = (uv) - float2(min(frac(_Time.y) - _ReelJitter, 0), 0);
					float2 absPos = float2(abs(correctPos));
					float4 reelGrab = float4(color.rgb, 1.);
					float testDirection = lerp(absPos.x, absPos.y, clamp(_ReelMode, 0, 1));
					if (_ReelMode == 3) {
						testDirection = lerp(testDirection, lerp(absPos.x, absPos.y, 2), 0.2);
						_ReelMode = 1;
					}
					else if (_ReelMode == 4) {
						testDirection = lerp(testDirection, lerp(absPos.x, absPos.y, 2), -0.4);
						_ReelMode = 1;
					}
					//correctPos = mul(correctPos, r2d(radians(_ReelRot)));

					float correctDirection = lerp(correctPos.y, correctPos.x, clamp(_ReelMode, 0, 1));
					correctDirection = lerp(correctDirection, correctPos.y, map(clamp(_ReelMode, 0, 2), 0, 2, -1, 1));
					//correctDirection = mul(correctDirection, rot(radians(_ReelRot)));
					if (testDirection > 0.40 + _ReelWidth)
					{
						if (testDirection > (0.42 + _ReelBars + _ReelWidth) && testDirection < (0.48 - _ReelBars)) { //first down second up
							reelGrab.rgb =
								insideColor *
								step(mod(_ReelBarAmounts * (correctDirection + (_Time.y) * _ReelSpeed), 1.0)*(1.0 - _ReelColor), 0.8 - _ReelBarHeight); //0.8 bar distance, 10 = bar amount
						}
						else {
							reelGrab = _ReelColor;
						}
					}

					color = lerp(color, lerp(color, reelGrab, _ToggleReel), _ReelPower);
				}

				

				UNITY_BRANCH if (_RenderMode == 1){
					if( grabPos.y < _renderOutlineSize || grabPos.y > 1. - _renderOutlineSize|| grabPos.x < _renderOutlineSize|| grabPos.x > 1. - _renderOutlineSize) {
						color = float4(_renderOutlineColor.rgb, _renderOutlineAlpha);
					}
				}
				UNITY_BRANCH if (_RenderMode == 3 || _RenderMode == 4) {
					if( grabPos.y < _renderOutlineSize || grabPos.y > 1. - _renderOutlineSize|| grabPos.x < _renderOutlineSize|| grabPos.x > 1. - _renderOutlineSize) {
						color = float4(_renderOutlineColor.rgb, _renderOutlineAlpha);
					}
					if( grabPos.y < 0. || grabPos.y > 1. || grabPos.x < 0. || grabPos.x > 1.) {
						color = float4(_renderColor.rgb, _renderColorAlpha);
					}
					
				}

				
				

				return color * i.falloff;
			} //frag