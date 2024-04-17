            //preset
				#define MAGNIFICATION_SIMPLE_SCALE 1 
				#define MAGNIFICATION_ZOOM 2 
				#define MAGNIFICATION_ZOOM_FALLOFF 3 
				#define MAGNIFICATION_CENTERING 4
				#define MAGNIFICATION_GRAVITATIONAL_LENS 5
				#define MAGNIFICATION_DEPTH_ZOOM 6

				#define BLUR_HORIZONTAL 1
				#define BLUR_STAR 2
				#define BLUR_CIRCLE 3
				#define BLUR_RADIAL 4

				#define CHROMATIC_ABERRATION_VECTOR 1
				#define CHROMATIC_ABERRATION_RADIAL 2

				#define ABERRATION_QUALITY_SIMPLE_SPLIT 0
				#define ABERRATION_QUALITY_MULTISAMPLING 1
	
				// on off
				uniform int Particle_Render;
				uniform int Magnification;
				uniform int ScreenRotation;
				uniform int Shake;
				uniform int Pixelization;
				uniform int Distorsion;
				uniform int Wave_Distorsion;
				uniform int Texture_Distorsion;
				uniform int Blur;
				uniform int Blur_Distorsion;
				uniform int Chromatic_Aberration;
				uniform int Aberration_Quality;
				uniform int CA_Distorsion;
				float _CARotation, _CARotationSpeed;
				uniform int Neon;
				uniform int HSV_Selection;
				uniform int HSV_Desaturate_Selected;
				uniform int HSV_Transform;
				uniform int Color_Tint;
				uniform int ACES_Tonemapping;
				uniform int Posterization;
				uniform int Dithering;
				uniform int Dithering_Colorize;
				uniform int Overlay_Texture;
				uniform int Overlay_Grid;
				uniform int Overlay_Texture_Sheet;
				uniform int Glitch;
				uniform int Vignette;
				uniform int Static_Noise;

				//texture shit i think
				uniform SamplerState linear_mirror_sampler;
				#define grabSampler linear_mirror_sampler

				static const uint LeftEye = 0;
				static const uint RightEye = 1;
				
				//Falloff
				uniform float _MinRange;
				uniform float _MaxRange;

				//FX Vars
				uniform float _Glitch_Intensity;
				uniform float _Glitch_BlockSize;
				uniform float _Glitch_UPS;
				uniform float _Glitch_Macroblock;
				uniform float _Glitch_Blocks;
				uniform float _Glitch_Lines;
				uniform float _Glitch_ActiveTime;
				uniform float _Glitch_PeriodTime;
				uniform float _Glitch_Duration;
				uniform float _Glitch_Displace;
				uniform float _Glitch_Pixelization;
				uniform float _Glitch_Shift;
				uniform float _Glitch_Grayscale;
				uniform float _Glitch_ColorShift;
				uniform float _Glitch_Interleave;
				uniform float _Glitch_BrokenBlock;
				uniform float _Glitch_Posterization;

				uniform float _Glitch_Displace_Chance;
				uniform float _Glitch_Pixelization_Chance;
				uniform float _Glitch_Shift_Chance;
				uniform float _Glitch_Grayscale_Chance;
				uniform float _Glitch_ColorShift_Chance;
				uniform float _Glitch_Interleave_Chance;
				uniform float _Glitch_BrokenBlock_Chance;
				uniform float _Glitch_Posterization_Chance;

				uniform float _Magnification;
				uniform float _Gravitation;
				uniform float _AngleStartFade;
				uniform float _MaxAngle;

				uniform float _SizeGirls;
				uniform float _TimeGirls;

				uniform sampler2D _DistorsionTex;
				uniform float4 _DistorsionTex_ST;
				uniform float4 _DistorsionTex_TexelSize;
				uniform float2 _DistorsionScroll;
				uniform float3 _DistorsionWave;
				uniform float3 _DistorsionWaveSpeed;
				uniform float3 _DistorsionWaveDensity;
				uniform float _DIntensity_X;
				uniform float _DIntensity_Y;

				uniform float _PSize_X;
				uniform float _PSize_Y;

				uniform float _PosterizationSteps;

				uniform float _ScreenRotation;
				uniform float _ScreenRotationSpeed;

				uniform sampler2D _ShakeTex;
				uniform float4 _ShakeTex_ST;
				uniform float2 _ShakeWave;
				uniform float2 _ShakeWaveSpeed;
				uniform float2 _ShakeScroll;
				uniform float _SIntensity_X;
				uniform float _SIntensity_Y;

				uniform float _ScreenHorizontalFlip;
				uniform float _ScreenVerticalFlip;

				uniform float _CA_dithering;
				uniform float _CA_amplitude;
				uniform float _CA_speed;
				uniform float _CA_iterations;
				uniform float _CA_factor;
				uniform float _CA_mask;
				uniform float2 _CA_direction;
				uniform float2 _CA_centerOffset;

				uniform float _Blur_Dithering;
				uniform float _BlurRange;
				uniform float _BlurIterations;
				uniform float _BlurRotation;
				uniform float _BlurRotationSpeed;
				uniform float _BlurMask;
				uniform float2 _BlurCenterOffset;
				uniform float3 _BlurColor;

				uniform float3 _EmissionColor;
				uniform float3 _Color;
				uniform float3 _Contrast;
				uniform float3 _Gamma;
				uniform float3 _Brightness;
				uniform float _ColorAlpha;
				uniform float _Grayscale;
				uniform float _RedInvert;
				uniform float _GreenInvert;
				uniform float _BlueInvert;

				uniform float3 _TargetColor;
				uniform float _HueRange;
				uniform float _SaturationRange;
				uniform float _LightnessRange;
				uniform float _HueSmoothRange;
				uniform float _SaturationSmoothRange;
				uniform float _LightnessSmoothRange;

				uniform float3 _TransformColor;
				uniform float _HueAnimationSpeed;
				uniform float _Hue;
				uniform float _Saturation;
				uniform float _Lightness;

				uniform float3 _NeonColor;
				uniform float3 _NeonOrigColor;
				uniform float _NeonColorAlpha;
				uniform float _NeonOrigColorAlpha;
				uniform float _NeonBrightness;
				uniform float _NeonPosterization;
				uniform float _NeonWidth;
				uniform float _NeonGlow;

				uniform float _MaskAmount;
				uniform float _StaticAlpha;
				uniform float _StaticBrightness;
				uniform float _StaticIntensity;
				uniform float3 _StaticColor;

				uniform float3 _VignetteColor;
				uniform float _VignetteAlpha;
				uniform float _VignetteWidth;
				uniform float _VignetteShape;
				uniform float _VignetteRounding;

				uniform int Mask_Texture;
				uniform int Mask_Multisampling;
				uniform int Mask_Noise;
				uniform sampler2D _MaskTex;
				uniform float4 _MaskTex_ST;
				uniform float3 _MaskColor;
				uniform float2 _MaskScroll;
				uniform float _MaskAlpha;

			
			
			// nextrix vars
			uniform int _RenderMode;
			uniform float4 _renderColor, _renderOutlineColor;
			uniform float _renderColorAlpha, _renderOutlineAlpha, _renderOutlineSize;

            
			uniform float _ZoomOutUV;

			//transition [COOL ASF ONG]
				uniform float _TransitionScreen;
				float4 _ScreenBounds;
				
				// TRot
					uniform float _TransRotationFG, _TransRotationBG, _TransRotationSpeed, _TRotRange, _TRotPower, _TInfRotation;
					uniform int _UseTransRotate;
				// TZoom
					uniform float _TBGScreenZoom, _TFRScreenZoom;
					
				// TDistort
					uniform float _TDSUVOrgin, _TDSUVAmp, _TDSUVDeformation, _TDSUVScale;
					uniform int _TUSEDSUV;
				// Tmove
					uniform float4 _TMovement;

			

			// acid defines
				#define ACIDTIME iTime*_AcidSpeed+_AcidTimeOffset
				#define ACIDRGB (0.5 + 0.5 * cos((iTime*_AcidRGBSpeed)+uv.xyxy+float4(0,2,4,1)) * _AcidRGBPower)
				#define ACIDCOLOR (_AcidColor) * ACIDRGB
			// 3drot
				inline float SP(){
					#if UNITY_SINGLE_PASS_STEREO
						return _ScreenParams.x*2/_ScreenParams.y;
					#else
						return _ScreenParams.x/_ScreenParams.y;
					#endif
				}

				#define asp SP()
				uniform int _Use3DRot, _BSIV;
				uniform float2 _rotcent;
				uniform float _Xrange, _XSpeed, _XManual;
				uniform float _Yrange, _YSpeed, _YManual;
				uniform float _Zrange, _ZSpeed, _ZManual;
			// void
            	uniform int SurfaceOfTheVoid;
				// Main UV
				uniform float _VuvPower, _VzoomOut;
				uniform float2 _VXYScale;
				uniform float3 _VXYMove;
				uniform float _Vrotate;

				//Controls 
				uniform float _VupDown, _VleftRight;
				uniform float _VSpeed, _Vdystroy, _Vhills, _VHillAmount, _VSmoothness;

				// Vignette
				uniform float _SurfVignette;

				//Colors
				uniform float _VBrightness;
				uniform float4 _VColor;

			// horror
				uniform int HorrorSpiral;
				// horror spiral

                //rendering
				uniform float _HAlphaBG;

				// tiling
				uniform float4 _Htile1;

				// Color
				uniform float4 _Hbase_Hcolor;

				//values
				uniform float _HColorSpeed, _HColorOffset, _HColorArea;
				uniform int _HColorFix;
				uniform float _HdistIter;
				uniform float _Hgray;
				uniform float4 _HColorMultiply, _HColor1, _HColor2;
				uniform float _HwobAmount,_HZSpeed, _HZOff, _HAlphaSpiral, _HorrorVignette, _HwobOffset;
				uniform float2 _HXYOff;
				uniform float _HSpiralColorSpeed, _HSpiralColorOffset, _HSpiralColorArea, _HspiralRotIter;
				uniform int _HUSEHUE_HON, _HUSEHUE_HON2, _HROTTYPE;
				uniform float _HZoom;
				uniform float _Halpha;

                uniform float _HOffset;

				float2 _HXYScale, _HXYMove, _HorrorMov;

				//de
				uniform bool _Hwobble;
				uniform float _HspiralIter,_HColorPow,_HspiralRot,_HspiralRotOffset, _Hthickness, _Hedges, _HValue3, _Hcomplex;

				//hue
				uniform float _HHueoffset, _HHueoffset2, _HHuespeed, _HHuespeed2;

			// voxel tunnel
				uniform int _VoxelTunnelToggle;
				uniform float4 _VoxelMovement;
				uniform float _VoxelAlpha, _VoxelZoom, _VoxelSpeed, _VoxelSpeedOffset, _VoxelVignette;
				uniform float4 _VoxMain, _VoxHighlights, _VoxRingCol;
			// Nextrix Spiral
				uniform float _NSpriZoom, _NSpriSpeed, _NSpriSpeedOff, _NSpriRot, _NSpriShake, _NSpriDist, _NSpriIterations, _NSpriOctaSize, _NSpriOffset;
				uniform float _NSpriAlpha, _NSpriPower, _NSpriVignette;
				uniform float4 _NSpriColor, _NSpriMovement;
				uniform int _NSpriToggle, _NSpriManual, _NSpriOverlay;
				
			// bars
				uniform float _zoomOutBars;
				uniform float2 _XYScaleBars, _XYMoveBars;
				uniform float _barsRotate;

				uniform int BarsToggle;
				uniform float _PowerAll;
				uniform float _Top, _Bottom, _Left, _Right;
				uniform float _outlineOffset, _outlineShift;
				uniform int _DistortType;
				uniform float _distortDeformation, _distortScale, _distortPower, _distortSpeed;
				uniform int _BarsVignette;
				uniform float2 _XYScaleVignette, _XYMoveVignette;
				uniform float _vigPower, _vigAlpha;
				uniform float4 _barsColor, _outlineColor;
				uniform int _UseOutlineHue;
				uniform float _hueOutlinePower, _hueOutlineSpeed, _hueOutlineOffset;
				#define BARS_RAND_SEED (283846.698)

			// frost
				uniform int _UseFrost;
				uniform float _FrostPower, _FrostSeed, _FrostSpeed;

			// Pixelsort
				uniform int _UsePixelSort, _SortAxis;
				uniform float _PixelsortAlpha, _PixelsortPower, _PixelsortRotation, _PixelsortUV, _PixelsortIterations;

			// particles
				uniform int _UsingParticles;
				uniform float _PartVig, _PartBGVignette, _PartSpeed, _PartTOFF, _PartRot, _PartInfRot, _PartAmount, _PartBGAlpha, _PartLength;  // effect controls
				uniform float _PartIter, _PartWavePower, _PartLinePow;
				uniform float3 _PartColor;

			// screen FilmReel
				uniform float4 _FRBGColor;
				uniform float _FRScrollSpeedOffset, _FRScrollSpeed, _FRScreenSize, _FRCenter, _FRScreenAlpha, _FRBorderFade, _FRpower;
				uniform float _FRrotateUV, _FRzoomOut;
				uniform int _FRScreen, _FRFixed_Center, _FRScroll_Direction;

            // bars FilmReel
				uniform float _ReelPower, _ReelRot, _ReelBars, _ReelBarHeight, _ReelWidth, _ReelJitter, _ReelSpeed;
				uniform float4 _ReelColor, _ReelInsideColor;
				uniform int _ToggleReel, _ReelMode, _ReelBarAmounts;

			// uv dupe
				float _columns, _rows, _DupeDist;
				int _FLOORUVDUPE, _USEUVDUPE;


			// tan transition
				uniform float _TanTransitionSpeed, _TanTransitionSpeedOffset, _TanTransitionPower, _TanTransitionZoom, _TanTransitionVignette, _TanTransitionAlpha;
            	uniform int _TanTransitionMatrixMode;
				uniform int _UseTanTransition;

			// fract lines
				float _XAmntFractLines, _FractLinesDist, _FractLinesOrgin;
				int _USEFRACTLINES, _FLOORFRACTLINES;

			// zoomloop
				float _LoopAlpha, _Screens, _Screens2, _LoopDist, _ScreensOffset, _RotateScreenLoop, _RotateScreenLoopSpeed;
				int _USEZOOMLOOP, _FLOORSCREENLOOP;

			// circle distortion
				float _DSCircleAmnt, _DSCircleOffset, _DSCircleSpeed, _DSCirclePower, _DSCircleOrgin;
				int _USEDSCircle;

			// uv distortion
				float _DSUVOrgin, _DSUVAmp, _DSUVDeformation, _DSUVScale;
				int _USEDSUV;

			// mirror
				float _mirrorXAmnt; 
				float _mirrorYAmnt;

			// waves
				int _UseWaves, _WaveAxis;
				float _WavesPower, _WavesSpeed, _WavesStrength;

			// flag
				int _UseFlag, _FlagAxis;
				float _FlagPower, _FlagSpeed, _FlagStrength, _FlagAmount, _FlagOffset;
			
			// circular split
				uniform int _UseCSplit;
				uniform float _CSplitPower, _CSplitStrength, _CSplitIter;

			// acid
				uniform int _Acid;
				uniform float _AcidPower; // 2
				uniform float _AcidAlpha; // 1
				uniform float _AcidIter; // 8
				uniform float _AcidSpeed; // 0.5
				uniform float _AcidTimeOffset; // 0
				uniform float4 _AcidColor; // float4(1,1,1,1);
				uniform float _AcidRGBPower; // 0.0
				uniform float _AcidRGBSpeed; //1.5
			// clamped rotation
				uniform int _UseRotation;
				uniform float _RotationStrength, _RotationPower, _RotationSpeed;
			// scanlines
				uniform int _UseScanlines;
				uniform float4 _ScanlinesColor;
				uniform float _ScanlinesPower, _ScanlinesRot, _ScanlinesSpeed, _ScanLinesIter;
			
			// dither
				uniform int _UseUVDither;
				uniform float4 _DitherColor;
				uniform float _DitherPower, _DitherScale, _DitherCenter;

			// outline "borrowed" from luka
				static const float3 lumaWeighting = float3(0.29, 0.59, 0.11);
				uniform int _UseOutline;
				uniform float4 _OutlineColor;
				uniform float _OutlinePower, _OutlineTolerance, _OutlineSize;
				uniform int _ORenderMode;

				// shake
					uniform float _OShakeAmpX, _OShakeAmpY, _OShakeFreqX, _OShakeFreqY, _OShakePower;
					uniform int _UseOShake;
				// zoom
					uniform float _OZoom;
				// movement
					uniform float4 _OMovement;
				// distortion
					uniform float _ODistDef, _ODistOrigin, _ODistIter, _ODistAmp;
					uniform int _UseODistortion;
			
			
			// Hash without Sine
			// https://www.shadertoy.com/view/4djSRW

		static const float4 hashScaleSmall = float4(443.8975, 397.2973, 491.1871, 444.129);
		static const float4 hashScale = float4(0.1031, 0.1030, 0.0973, 0.1099);

