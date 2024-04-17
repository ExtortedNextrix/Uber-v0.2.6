Shader "!nextrix/FX/Uber++ v0.2.6"
{ 
	Properties 
  { 
      [HideInInspector] shader_is_using_thry_editor("", Float)=0
	  [HideInInspector] shader_master_label("<color=#6CA0DC>Uber++</color><color=#89CFF0> v0.2.6</color>", Float) = 0
		//Main Settings
		[HideInInspector] m_start_MainUV ("Main UV", Float) = 0 // uv
			[Toggle()]Particle_Render("Particle system", Int) = 0
			//Fade Settings
			_MinRange ("Start fading", Float) = 9998
			_MaxRange ("End distance", Float) = 9999
			[Space(10)]
            //_mirrorXAmnt ("Mirror X", range(0,1)) = 1 // BUGGY WITH SHITTY VERTEX [ add back if u want just uncomment ]
            //_mirrorYAmnt ("Mirror Y", range(0,1)) = 1 // BUGGY WITH SHITTY VERTEX [ add back if u want just uncomment ]

			[HideInInspector] m_start_RenderMode ("Background", Float) = 0 // Rendering
				[Enum(Mirror, 0, Repeat, 1, Clamp, 2, Color, 3, Transition, 4)] _RenderMode ("Background Mode", Int) = 1
				[HDR]_renderColor ("Background Color", Color) = (0,0,0,1)
				_renderColorAlpha ("Background Alpha", range(0,1)) = 1
				[Space(10)]
				[HDR] _renderOutlineColor ("Outline Color", Color) = (1,1,1,1)
				_renderOutlineAlpha ("Outline Alpha", range(0,1)) = 1
				_renderOutlineSize ("Outline Size", range(0,1)) = 0
				[Space(10)]
				
				[HideInInspector] m_start_TransitionFX ("Transition", Float) = 0 // TransPeopleAreKindaOdd
					// literally just mask the screen and skid (reuse) the old effects lmfao
					_TransitionScreen("Transition", range(0,1)) = 0
					[Vector2] _ScreenBounds ("Screen Bounds", vector) = (1,0,0,0)
					[HideInInspector] m_start_TRot ("Rotation", Float) = 0 // ROT
						[Toggle()] _UseTransRotate ("Use Rotation", int) = 0
						_TRotPower ("Power", range(0,1)) = 1
						_TransRotationFG("Front Amount", float) = 0
						_TransRotationBG("Back Amount", float) = 0
						_TransRotationSpeed("Speed", float) = 0
						_TRotRange ("Range", float) = 4
						_TInfRotation ("Inf Rotation", float) = 0
					[HideInInspector] m_end_TRot ("Rotation", Float) = 0 // ROT

					[HideInInspector] m_start_TZoom ("Zoom", Float) = 0 // ZOOM
						_TFRScreenZoom("Front Zoom", range(0,1)) = 1
						_TBGScreenZoom("Background Zoom", range(0,1)) = 1
					[HideInInspector] m_end_TZoom ("Zoom", Float) = 0 // ZOOM

					[HideInInspector] m_start_TDist ("Distortion", Float) = 0 // DIST
						[Toggle() ]_TUSEDSUV ("Use UV Distortion", int) = 0
						_TDSUVDeformation ("Distortion Deformation", range(0,0.5)) = 0
						_TDSUVOrgin ("Distortion Scale", float) = 1
						_TDSUVScale ("Distortion Iterations", float) = 8
						_TDSUVAmp ("Distortion Speed", Float) = 3
					[HideInInspector] m_end_TDist ("Distortion", Float) = 0 // DIST

					[HideInInspector] m_start_TMove ("Movement", Float) = 0 // MOVE
						[Vector2] _TMovement ("Movement", vector) = (0,0,0,0)
					[HideInInspector] m_end_TMove ("Movement", Float) = 0 // MOVE

				[HideInInspector] m_end_TransitionFX ("TransitionFX", Float) = 0 // TransPeopleAreKindaOdd

			[HideInInspector] m_end_RenderMode ("Background", Float) = 0 // Rendering
		[HideInInspector] m_end_MainUV ("Main UV", Float) = 0 // uv

		[HideInInspector] m_start_UV ("UV", Float) = 0 // uv
			[HideInInspector] m_start_Glitch ("Glitch", Float) = 0 // Glitch
				[Toggle()]Glitch("Use Glitch", Int) = 0
				_Glitch_Intensity("Intensity", Range(0, 1)) = 0.1
				_Glitch_BlockSize("Block size", Float) = 10.0
				_Glitch_Macroblock("Macroblock subdivide", Range(0, 1)) = 0.3
				_Glitch_Blocks("Block Glitch", Range(0, 1)) = 0.25
				_Glitch_Lines("Line Glitch", Range(0, 1)) = 0.5
				_Glitch_UPS("Glitches per second", Float) = 15.0
				_Glitch_ActiveTime("Active Time", Range(0, 1)) = 0.4
				_Glitch_PeriodTime("Period Time", Float) = 6.0
				_Glitch_Duration("Long duration chance", Range(0, 1)) = 0.4
				_Glitch_Displace("Displace", Range(0, 1)) = 0.02
				_Glitch_Pixelization("Pixelization", Range(0, 1)) = 0.8
				_Glitch_Shift("Shift", Range(0, 1)) = 0.05
				_Glitch_Grayscale("Grayscale", Range(0, 1)) = 1
				_Glitch_ColorShift("Color shift", Range(0, 1)) = 0.1
				_Glitch_Interleave("Interleave lines", Range(0, 1)) = 0.5
				_Glitch_BrokenBlock("Broken blocks", Range(0, 1)) = 0.05
				_Glitch_Posterization("Posterization", Range(0, 1)) = 0.9
				_Glitch_Displace_Chance("Dispalce chance", Range(0, 1)) = 0.01
				_Glitch_Pixelization_Chance("Pixelization chance", Range(0, 1)) = 1
				_Glitch_Shift_Chance("Shift chance", Range(0, 1)) = 0.05
				_Glitch_Grayscale_Chance("Grayscale chance", Range(0, 1)) = 0.1
				_Glitch_ColorShift_Chance("Color shift chance", Range(0, 1)) = 1
				_Glitch_Interleave_Chance("Interleave lines chance", Range(0, 1)) = 0.05
				_Glitch_BrokenBlock_Chance("Broken block chance", Range(0, 1)) = 1
				_Glitch_Posterization_Chance("Posterization chance", Range(0, 1)) = 1
			[HideInInspector] m_end_Glitch ("Glitch", Float) = 0 // Glitch

			[HideInInspector] m_start_Zoom ("Zoom", Float) = 0 // Zoom
				//Zoom Settings
				[Enum(Off, 0, SimpleScale, 1, Zoom, 2, ZoomFalloff, 3, Centering, 4, GravitationalLens, 5)]Magnification("Mode", Int) = 0
				_Magnification("Scale", Range (-1, 1)) = 0.0
				_Gravitation("Gravitation range", Range (0, 100.0)) = 1.0
				_AngleStartFade("Angle range", Range (0, 1)) = 0.25
				_MaxAngle("Max angle range", Range (0, 1)) = 0.5
			[HideInInspector] m_end_Zoom ("Zoom", Float) = 0 // Zoom
			
			[HideInInspector] m_start_Girlscam ("Girlscam", Float) = 0 // Girlscam
				//Girlscam
				_SizeGirls("Size", Range(0, 1)) = 0
				_TimeGirls("Time", Range(0, 1)) = 1
			[HideInInspector] m_end_Girlscam ("Girlscam", Float) = 0 // Girlscam

			[HideInInspector] m_start_Rotation ("Rotation", Float) = 0 // Rotation
				//Rotation Z
				[Header(Z Axis Rotation)]
				[Toggle()]ScreenRotation("Use Z Rotation", Int) = 0
				_ScreenRotation("Angle", Float) = 0.1
				_ScreenRotationSpeed("Shake speed", Float) = 2.0
				[Header(2D Rotation)]
				[Space(5)]
				[Enum(Off, 0, Stretched, 1)] _UseRotation ("Rotation Mode", int) = 0
				_RotationPower ("Rotation Power", range(0,1)) = 0
				_RotationStrength ("Rotation Strength", float) = 0
				_RotationSpeed ("Rotation Inf Speed", float) = 0
				[Header(3D Rotation)]
				[Space(5)]
				[Toggle()]_Use3DRot("Use 3D Rotation", int) = 0
				[Vector2D]_rotcent("Center", vector) = (0,0,0,0)
				[Space(10)] // temmie smells
				_Xrange("X Range", Float) = 0
				_XSpeed("X Speed", Float) = 0
				_XManual("X Manual", Float) = 0
				[Space(10)]// temmie smells
				_Yrange("Y Range", Float) = 0
				_YSpeed("Y Speed", Float) = 0
				_YManual("Y Manual", Float) = 0
				[Space(10)]// temmie smells
				_Zrange("Z Range", Float) = 0
				_ZSpeed("Z Speed", Float) = 0
				_ZManual("Z Manual", Float) = 0

				
			[HideInInspector] m_end_Rotation ("Rotation", Float) = 0 // Rotation

			[HideInInspector] m_start_Transform ("Transform", Float) = 0 // Transform
				//Screen Transform
				_ScreenHorizontalFlip("Horizontal", Range(0.0, 1.0)) = 0
				_ScreenVerticalFlip("Vertical", Range(0.0, 1.0)) = 0
			[HideInInspector] m_end_Transform ("Transform", Float) = 0 // Transform

			[HideInInspector] m_start_Shake ("Shake", Float) = 0 // Shake
				//Screen Shake
				[Toggle()]Shake("Use Shake", Int) = 0
				[Normal][NoScaleOffset]_ShakeTex("Normalmap", 2D) = "bump" {}
				_SIntensity_X ("Intensity X", Range(0, 1)) = 0.01
				_SIntensity_Y ("Intensity Y", Range(0, 1)) = 0.01
				_ShakeScroll("Texture Scroll(XY)", Vector) = (2, 0.02, 0, 0)
				_ShakeWave("Wave offset(XY)", Vector) = (0.01, 0.01, 0, 0)
				_ShakeWaveSpeed("Wave speed(XY)", Vector) = (20, 19, 0, 0)
			[HideInInspector] m_end_Shake ("Shake", Float) = 0 // Shake

			[HideInInspector] m_start_Pixelation ("Pixelation", Float) = 0 // Pixelation
				//Pixelation
				[Toggle()]Pixelization("Use Pixelation", Int) = 0
				_PSize_X ("Pixel Width", Range(1.0, 128.0)) = 4.0
				_PSize_Y ("Pixel Height", Range(1.0, 128.0)) = 4.0
			[HideInInspector] m_end_Pixelation ("Pixelation", Float) = 0 // Pixelation

			[HideInInspector] m_start_Distortion ("Distortion", Float) = 0 // Distortion
				//Screen Distortion
				[Header(Texture Distortion)]
					[Space(5)]
					[Toggle()]Distorsion("Use Texture Distortion", Int) = 0
					[Toggle()]Wave_Distorsion("Wave Active", Int) = 1
					[Toggle()]Texture_Distorsion("Texture Active", Int) = 0
					[Normal]_DistorsionTex("Normalmap", 2D) = "bump" {}
					_DIntensity_X ("Horizontal", Range(0, 10)) = 0.01
					_DIntensity_Y ("Vertical", Range(0, 10)) = 0.01
					[Vector2]_DistorsionScroll("Scroll Texture", Vector) = (0, 0, 0, 0)
					[Vector3]_DistorsionWave("Wave offset", Vector) = (0.01, 0.01, 1, 0)
					[Vector3]_DistorsionWaveSpeed("Wave speed", Vector) = (2.6, -3.1, 1, 0)
					[Vector3]_DistorsionWaveDensity("Wave density", Vector) = (8.4, 3, 1, 0)
				[Header(UV Distortion)]
					[Space(5)]
					[Toggle() ]_USEDSUV ("Use UV Distortion", int) = 0
					_DSUVDeformation ("Distortion Deformation", range(0,0.5)) = 0
					_DSUVOrgin ("Distortion Scale", float) = 1
					_DSUVScale ("Distortion Iterations", float) = 8
					_DSUVAmp ("Distortion Speed", Float) = 3
			[HideInInspector] m_end_Distortion ("Distortion", Float) = 0 // Distortion

			[HideInInspector] m_start_uvdupe ("UV Dupe", Float) = 0 // UV Dupe
				[Toggle()] _USEUVDUPE ("Use UV Dupe", int) = 0
				[Toggle()] _FLOORUVDUPE ("Floor Screen Values?", int) = 1
				_DupeDist ("Back to Orgin", range(0,1)) = 1
				_columns ("Columns", range(-20,20)) = 0
				_rows ("Rows", range(-20,20)) = 0
			[HideInInspector] m_end_uvdupe ("UV Dupe", Float) = 0 // UV Dupe

			[HideInInspector] m_start_fractlines ("Fract Lines", Float) = 0 // Fract Lines
				[Toggle()] _USEFRACTLINES ("Use Fract Lines", int) = 0
				[Toggle()] _FLOORFRACTLINES ("Floor Screen Values?", int) = 1
				_XAmntFractLines ("X Amount", float) = 10
				_FractLinesDist ("Distance", float) = 0.02
				_FractLinesOrgin ("Distance from Orgin", float) = 1
			[HideInInspector] m_end_fractlines ("Fract Lines", Float) = 0 // Fract Lines

			[HideInInspector] m_start_NormLoop("Screen Loop", Float) = 0 // ScreenLoop
				[Toggle()] _USEZOOMLOOP ("Use Screen Loop", int) = 0
				[Toggle()] _FLOORSCREENLOOP ("Floor Screen Values?", int) = 1
				_LoopAlpha ("Screen Loop Alpha", range(0,1)) = 1
				_Screens ("Screen Amount", float) = 8
				_ScreensOffset ("Screen Offset", float) = 10
				_RotateScreenLoop ("Rotation", float) = 0
				_RotateScreenLoopSpeed ("Rotation Speed", float) = 0
			[HideInInspector] m_end_NormLoop("Normal", Float) = 0 // ScreenLoop

			[HideInInspector] m_start_TanTransition("Tangent Transition", Float) = 0 // Tan Transition
				[Toggle()] _UseTanTransition ("Use Tan Transition", int) = 0
				_TanTransitionAlpha ("Alpha", range(0,1)) = 1
				_TanTransitionVignette ("Vignette", range(0,1)) = 0
				_TanTransitionPower ("Transition Power", range(-0.5,2)) = 1
				[IntRange]_TanTransitionMatrixMode ("Matrix Mode", range(1,6)) = 6
				_TanTransitionZoom ("Zoom", float) = 1
				_TanTransitionSpeed ("Speed", float) = 1
				_TanTransitionSpeedOffset ("Speed Offset", float) = 0
			[HideInInspector] m_end_TanTransition("Tangent Transition", Float) = 0 // Tan Transition

			[HideInInspector] m_start_CircSplit("Circular Spread", Float) = 0 // Circular Spread
				[Toggle()] _UseCSplit ("Use Circular Spread", int) = 0
				_CSplitPower ("Power", range(0,1)) = 0
				_CSplitStrength ("Strength", float) = 1000
				_CSplitIter ("Iter", float) = 20
			[HideInInspector] m_end_CircSplit("Circular Spread", Float) = 0 // Circular Spread

			
			[HideInInspector] m_start_Waves("Waves", Float) = 0 // Waves
				[Toggle() ]_UseWaves ("Use Waves", int) = 0
				[Enum(X Axis, 0, Y Axis, 1, Both, 2)] _WaveAxis ("Axis", Int) = 0
				_WavesPower ("Power", range(0,0.1)) = 0.04
				_WavesStrength ("Strength", range(0,25)) = 10
				_WavesSpeed ("Speed", float) = 5
			[HideInInspector] m_end_Waves("Waves", Float) = 0 // Waves

			[HideInInspector] m_start_Flag("Flag", Float) = 0 // Flag
				[Toggle() ]_UseFlag ("Use Flag", int) = 0
				[Enum(X Axis, 0, Y Axis, 1, Both, 2)] _FlagAxis ("Axis", Int) = 0
				_FlagPower ("Cut Off", range(0,1.)) = 1
				_FlagStrength ("Flag Strength", range(0,5)) = 1
				_FlagAmount ("Flag Amount", range(0,15)) = 5
				_FlagOffset ("Flag Offset", float) = 0
				_FlagSpeed ("Speed", float) = 1
			[HideInInspector] m_end_flag("Flag", Float) = 0 // Flag


			[HideInInspector] m_start_Frost ("Frost", Float) = 0 // Frost
				[Toggle()] _UseFrost ("Use Frost", int) = 0
				_FrostPower ("Power", range(-1,1)) = 0
				_FrostSpeed ("Speed", range(0,25)) = 1
				_FrostSeed ("Seed", float) = 5
			[HideInInspector] m_end_Frost ("Frost", Float) = 0 // Frost

			[HideInInspector] m_start_PixelSort ("Pixel Sort", Float) = 0 // Pixelsort
				[Toggle()] _UsePixelSort ("Use Pixel Sort", int) = 0
				_PixelsortAlpha("Alpha", range(0,1)) = 1
				_PixelsortUV ("UV -> Color", range(0,1)) = 0
				_PixelsortPower("Power", range(0,2.6)) = 0
				_PixelsortIterations ("Iterations", float) = 437.5
				_PixelsortRotation("Jitter", float) = 512
			[HideInInspector] m_end_PixelSort ("Pixel Sort", Float) = 0 // Pixelsort
		[HideInInspector] m_end_UV ("UV", Float) = 0 // uv

		[HideInInspector] m_start_Color ("Color", Float) = 0 // Color
			[HideInInspector] m_start_Blur ("Blur", Float) = 0 // Blur
				//Blur Settings
				[Enum(Off, 0, Horizontal, 1, Star, 2, Circle, 3, Radial, 4)]Blur("Mode", Int) = 0
				[Toggle()]Blur_Distorsion("Blur with Distorsion", Int) = 0
				[Toggle()]_Blur_Dithering("Dithering", Float) = 1
				[HDR]_BlurColor("Blur Color (RGB)", Color) = (1,1,1,1)
				_BlurRange ("Offset", Range(0, 1)) = 0.01
				_BlurRotation ("Rotation", Float) = 0.0
				_BlurRotationSpeed("Rotation speed", Float) = 0
				_BlurIterations ("Samples", Range(1, 128)) = 8.0
				_BlurCenterOffset("Center offset(XY)", Vector) = (0, 0, 0, 0)
				_BlurMask("Mask effect", Range(0.0, 1.0)) = 0.5
			[HideInInspector] m_end_Blur ("Blur", Float) = 0 // Blur

			[HideInInspector] m_start_CA ("Chromatic Aberration", Float) = 0 // Chromatic Aberration
				//Chromatic Aberration
				[Enum(Off, 0, Vector, 1, Radial, 2)]Chromatic_Aberration("Mode", Int) = 0
				[Enum(SimpleSplit, 0, MultiSampling, 1)]Aberration_Quality("Quality", Int) = 1
				[Toggle()]CA_Distorsion("Use Distorsion", Int) = 0
				[Toggle()]_CA_dithering("Dithering", Float) = 1
				_CA_amplitude("Offset", Range(0.0, 15.0)) = 0.015
				_CA_iterations ("Samples", Range(1, 128.0)) = 8.0
				_CA_speed("Animation Speed", Float) = 0.0
				_CARotation ("Rotation", float) = 0
				_CARotationSpeed ("Rotation Speed", float) = 0
				_CA_factor ("Effect", Range(0, 1.0)) = 1.0
				_CA_centerOffset("Radial center offset", Vector) = (0, 0, 0, 0)
				_CA_mask("Mask effect", Range(0.0, 1.0)) = 0.5
			[HideInInspector] m_end_CA ("Chromatic Aberration", Float) = 0 // Chromatic Aberration

			//Neon
			[HideInInspector] m_start_Neon ("Neon", Float) = 0 // Neon
				[Toggle()]Neon("Active", Int) = 0
				[HDR]_NeonColor("Tint (RGB)", Color) = (1, 1, 1, 1)
				_NeonColorAlpha("Intensity", Range(0.0, 1.0)) = 1.0
				_NeonOrigColor("Background Color (RGB)", Color) = (0.25, 0.25, 0.25, 1)
				_NeonOrigColorAlpha("Background mix", Range(0.0, 1.0)) = 1.0
				_NeonBrightness("Brightness", Float) = 3.0
				_NeonPosterization("Posterization", Range (0.0, 1.0)) = 1.0
				_NeonWidth("Width", Float) = 1.5
				_NeonGlow("Glow", Range (0.0, 1.0)) = 1.0
			[HideInInspector] m_end_Neon ("Neon", Float) = 0 // Neon

			//HSV Color Space
			[HideInInspector] m_start_HSV ("HSV Coloring", Float) = 0 // HSV
				[Toggle()]HSV_Selection("Active", Int) = 0
				_TargetColor("Select color (RGB)", Color) = (1,0,0,1)
				_HueRange("Hue range", Range(0, 0.5)) = 0.02
				_SaturationRange("Saturation range", Range(0, 1)) = 0.4
				_LightnessRange("Lightness range", Range(0, 1)) = 1
				_HueSmoothRange("Hue fade", Range(0, 0.5)) = 0.02
				_SaturationSmoothRange("Saturation fade", Range(0, 1)) = 0.1
				_LightnessSmoothRange("Lightness fade", Range(0, 1)) = 1
				[Toggle()]HSV_Desaturate_Selected("Desaturate", Int) = 1
				[HideInInspector] m_start_HSVExtra ("Extra", Float) = 0 // HSV Extra
					//Extra Settings
					[Toggle()]HSV_Transform("Active", Int) = 0
					_TransformColor("Color (RGB)", Color) = (0, 0, 1, 1)
					_Hue("Hue value", Range(0, 1)) = 1.0
					_HueAnimationSpeed("Hue Animation Speed", Float) = 0.0
					_Saturation("Saturation value", Range(0, 1)) = 0
					_Lightness("Lightness value", Range(0, 1)) = 0
				[HideInInspector] m_end_HSVExtra ("Extra", Float) = 0 // HSV Extra
			[HideInInspector] m_end_HSV ("HSV Coloring", Float) = 0 // HSV

			
			[HideInInspector] m_start_CC ("Color Correction", Float) = 0 // Color Correction
				//Color Correction
				[Toggle()]Color_Tint("Active", Int) = 0
				[Toggle()]ACES_Tonemapping("ACES Tonemapping", Int) = 0
				[HDR]_EmissionColor("Emission color (RGB)", Color) = (0, 0, 0, 1)
				[HDR]_Color("Mix color (RGB)", Color) = (0, 0, 0, 0)
				_ColorAlpha("Mix factor", Range(0.0, 1.0)) = 0.0
				_Grayscale("Grayscale", Range (0.0, 1.0)) = 0.0
				_Contrast("Contrast", Vector) = (1.0, 1.0, 1.0, 1.0)
				_Gamma("Gamma", Vector) = (1.0, 1.0, 1.0, 1.0)
				_Brightness("Brightness", Vector) = (1.0, 1.0, 1.0, 1.0)
				_RedInvert("Red Invert", Range (0.0, 1.0)) = 0.0
				_GreenInvert("Green Invert", Range (0.0, 1.0)) = 0.0
				_BlueInvert("Blue Invert", Range (0.0, 1.0)) = 0.0
			[HideInInspector] m_end_CC ("Color Correction", Float) = 0 // Color Correction

			[HideInInspector] m_start_posterization ("Posterization", Float) = 0 // Posterization
				//Posterization
				[Toggle()]Posterization("Active", Int) = 0
				_PosterizationSteps("Gradient steps", Range(1.0, 256.0)) = 16.0
			[HideInInspector] m_end_posterization ("Posterization", Float) = 0 // Posterization

			[HideInInspector] m_start_Static ("Static", Float) = 0 // Static
				//Static
				[Toggle()]Static_Noise("Active", Int) = 0
				[HDR]_StaticColor("Color", Color) = (1,1,1,1)
				_StaticIntensity("Intensity", Range(-1, 1)) = -0.34
				_StaticAlpha("Alpha", Range(0,1)) = 0.17
				_StaticBrightness("Brightness", Range(0, 1)) = 1.0
				[HideInInspector]_MaskAmount("Mix Amount (WIP)", Range(0,1)) = 0
			[HideInInspector] m_end_Static ("Static", Float) = 0 // Static

			[HideInInspector] m_start_Vignette ("Vignette", Float) = 0 // Vignette
				//Vignette
				[Toggle()]Vignette("Active", Int) = 0
				_VignetteColor("Color (RGB)", Color) = (0, 0, 0, 1)
				_VignetteAlpha("Transparent", Range(0, 1)) = 0.15
				_VignetteWidth("Width", Float) = 0.5
				_VignetteShape("Shape", Range(-1, 1)) = 0.5
				_VignetteRounding("Rounding", Range(0, 1)) = 0.5
			[HideInInspector] m_end_Vignette ("Vignette", Float) = 0 // Vignette

			[HideInInspector] m_start_Bars ("BarsFX", Float) = 0 // Bars
				[Toggle()] BarsToggle ("Use Bars", Int) = 0
				[HideInInspector] m_start_BarsSettings ("Bars Settings", Float) = 0 // Bars Settings
					[HDR]_barsColor("Color", Color) = (.0, .0, .0)
					_PowerAll("Power All", range(0,1)) = 0.5
					_Top ("Power Top", range(0,0.5)) = 0.35
					_Bottom ("Power Bottom", range(0,0.5)) = 0.35
					_Left ("Power Left", range(0,0.6)) = 0
					_Right ("Power Right", range(0,0.6)) = 0
					_zoomOutBars ("Zoom", Float) = 1
					_barsRotate ("Rotate", float) = 0
					[Vector2] _XYScaleBars("XY Scale", Vector) = (1, 1, 0, 0)
					[Vector2] _XYMoveBars("XY Move", Vector) = (0, 0, 0, 0)
				[HideInInspector] m_end_BarsSettings ("Bars Settings", Float) = 0 // Bars Settings

				[HideInInspector] m_start_BarsSettingsOutline ("Bars Outline", Float) = 0 // Bars Outline
					[HDR]_outlineColor("Color", Color) = (1., 1., 1.)
					_outlineOffset ("Size", range(0,0.1)) = 0.01
					_outlineShift ("Color Shift", range(0,1)) = 0
					[HideInInspector] m_start_BarsSettingsOutlineHue ("Hue", Float) = 0 // Bars Outline Hue
						[Enum(Off, 0, Normal, 1, Wave, 2)]_UseOutlineHue ("Use Hue", int) = 0
						_hueOutlinePower ("Power", range(0,2)) = 1
						_hueOutlineSpeed ("Speed", float) = 1
						_hueOutlineOffset ("Offset", float) = 3
					[HideInInspector] m_end_BarsSettingsOutlineHue ("Hue", Float) = 0 // Bars Outline Hue

				[HideInInspector] m_end_BarsSettingsOutline ("Bars Outline", Float) = 0 // Bars Outline

				[HideInInspector] m_start_Distortion ("Bars Distortion", Float) = 0 // Bars Distortion
					[Enum(Normal, 0, Cos, 1, Spiral, 2)] _DistortType ("Distortion Type", Int) = 0
					_distortDeformation ("Distortion Deformation", range(-1, 1)) = 0.05
					_distortScale ("Distortion Scale", float) = 10.0
					_distortPower ("Distortion Iterations", float) = 2.
					_distortSpeed ("Distortion Speed", float) = 2.0
				[HideInInspector] m_end_Distortion ("Bars Distortion", Float) = 0 // Bars Distortion

				[HideInInspector] m_start_Extra ("Extra", Float) = 0 // Extra
					[HideInInspector] m_start_Vig ("Vignette", Float) = 0 // Vignette
						[Toggle] _BarsVignette ("Use Bars Vignette", Int) = 0
						[Vector2] _XYScaleVignette("XY Scale", Vector) = (0.8, 1, 0, 0)
						[Vector2] _XYMoveVignette("XY Move", Vector) = (0, 0, 0, 0)
						_vigAlpha ("Smoothness", range(0,1)) = 0
						_vigPower ("Power", range(0,1)) = 0
					[HideInInspector] m_end_Vig ("Vignette", Float) = 0 // Vignette

					[HideInInspector] m_start_Grid ("Grid", Float) = 0 // Grid
						
						[Enum(Off, 0, Square, 1, Triangle, 2)] _GridType ("Grid Type", Int) = 0
						[Vector2] _XYScaleGrid("XY Scale", Vector) = (1, 1, 0, 0)
						[Vector2] _XYMoveGrid("XY Move", Vector) = (0, 0, 0, 0)
						_zoomOutGrid ("Zoom", Float) = 1
						_rotGrid ("Rotate", Float) = 0
						_sizeGrid ("Grid Size", Range(0, 1)) = 0.5
						[Toggle] _InvertGrid ("Invert Grid", Int) = 0
						[Toggle] _GridDistort ("Distort Grid", Int) = 0
					[HideInInspector] m_end_Grid ("Grid", Float) = 0 // Grid

				[HideInInspector] m_end_Extra ("Extra", Float) = 0 // Extra

			[HideInInspector] m_end_Bars ("Bars", Float) = 0 // Bars

			[HideInInspector] m_start_BarsFR ("FilmReel", Float) = 0
				[Toggle()]_ToggleReel ("Film Reel", Float) = 0
				_ReelPower ("Reel Strength", Range(0, 1)) = 1
				[Enum(Vertical, 0, Horizontal, 1, Scroll, 2, Peak, 3, Diamond, 4)] _ReelMode ("Reel Direction", Float) = 3
				_ReelSpeed ("Reel Speed", Range(-2, 2)) = 1
				[HDR]_ReelColor ("Reel Color", Color) = (0, 0, 0, 1)
				[HDR]_ReelInsideColor ("Inside Reel Color", Color) = (0.7, 0.7, 0.7, 1)
				_ReelRot("Bar Rotation", float) = 0
				_ReelBars ("Bar Thickness", Range(-1, 1)) = 0
				_ReelBarHeight ("Bar Heigth", Range(-1, 1)) = 0
				_ReelWidth ("Reel Width", Range(1, -1)) = 0
				_ReelJitter ("Reel Jitter", Range(0, 0.05)) = 0
				[IntRange] _ReelBarAmounts ("Reel Number Bars", Range(0, 20)) = 10
			[HideInInspector] m_end_BarsFR ("FilmReel", Float) = 0

			[HideInInspector] m_start_Particles ("Particles", Float) = 0 // Particles
				[Toggle()]_UsingParticles ("Active", int) = 0
				[HDR] _PartColor ("Color", Color) = (1,1,1)
				_PartBGAlpha ("Power", Range(0,3)) = 3
				_PartRot ("Rotate", Float) = 1
				_PartInfRot ("Rotate Speed", Float) = 0
				_PartSpeed ("Speed", float) = 1
				_PartTOFF ("Time Offset", float) = 0
				_PartAmount ("Line Amount", float) = 365
				_PartIter ("Iterations", float) = 8
				_PartWavePower ("Wave Power", float) = 9
				_PartLength ("Line Length", float) = 2.5
				_PartLinePow ("Line Power", range(-1,1)) = 1
				_PartVig ("Vignette Power", range(0,1)) = 0
			[HideInInspector] m_end_Particles ("Particles", Float) = 0 // Particles

			[HideInInspector] m_start_acid ("Acid", float) = 0 // Acid
				[Toggle()]_Acid ("Use Acid", int) = 0
				
				_AcidPower ("Power", range(0, 4)) = 2
				_AcidAlpha ("Acid Alpha", range(0,1)) = 1
				_AcidIter ("Acid Iterations", float) = 8
				_AcidSpeed ("Acid Speed", float) = 0.5
				_AcidTimeOffset ("Time Offset", float) = 0
				[Space(15)]
				[HDR] _AcidColor ("Color", Color) = (1,1,1,1)
				_AcidRGBPower ("RGB Power", range(-1,2)) = 0
				_AcidRGBSpeed ("RGB Speed", float) = 1.5
			[HideInInspector] m_end_acid ("Acid", float) = 0 // Acid
			
			[HideInInspector] m_start_scanlines ("Scanlines", float) = 0
				[Toggle()] _UseScanlines ("Use Scanlines", int) = 0
				[HDR] _ScanlinesColor ("Color", color) = (0.3,0.3,0.3,1)
				_ScanlinesPower ("Power", range(0,1)) = 0.5
				_ScanLinesIter ("Iterations", Range(0,64)) = 12
				_ScanlinesRot ("Rotation", float) = 90
				_ScanlinesSpeed ("Speed", float) = 2.5
			[HideInInspector] m_end_scanlines ("Scanlines", float) = 0

			[HideInInspector] m_start_dither ("Dither", float) = 0
				[Toggle()]_UseUVDither ("Use Dither", int) = 0
				[HDR] _DitherColor ("Color", color) = (0.4,0.4,0.4,1)
				_DitherPower ("Power", range(0,2)) = 1
				_DitherScale ("Scale", range(1,1024)) = 64
				_DitherCenter ("Center", range(0,1)) = 0.45
			[HideInInspector] m_end_dither ("Dither", float) = 0

			[HideInInspector] m_start_Outline ("Outline", float) = 0
				[Toggle()] _UseOutline ("Use Outline", int) = 0
				[Enum(Mirror, 0, Repeat, 1, Clamp, 2, Color, 3)] _ORenderMode ("Render Mode", Int) = 1
				[HDR] _OutlineColor ("Color", Color) = (1,1,1,1)
				_OutlinePower ("Power", range(0,1)) = 1
				_OutlineSize("Size", float) = 1
				_OutlineTolerance("Tolerance", float) = 1

				[HideInInspector] m_start_OZoom ("Zoom", Float) = 0 // ZOOM
					_OZoom("Zoom", range(0,1)) = 1
				[HideInInspector] m_end_OZoom ("Zoom", Float) = 0 // ZOOM

				[HideInInspector] m_start_OMove ("Movement", Float) = 0 // MOVE
					[Vector2] _OMovement ("Movement", vector) = (0,0,0,0)
				[HideInInspector] m_end_OMove ("Movement", Float) = 0 // MOVE

				[HideInInspector] m_start_ODist ("Distortion", Float) = 0 // DIST
					[Toggle() ]_UseODistortion ("Use Outline Distortion", int) = 0
					_ODistDef ("Distortion Deformation", range(0,0.5)) = 0
					_ODistOrigin ("Distortion Scale", float) = 1
					_ODistIter ("Distortion Iterations", float) = 8
					_ODistAmp ("Distortion Speed", Float) = 3
				[HideInInspector] m_end_ODist ("Distortion", Float) = 0 // DIST

				[HideInInspector] m_start_OShake ("Shake", Float) = 0 // SHAKE
					[Toggle()] _UseOShake ("Use Outline Shake", int) = 0
					_OShakePower ("Shake Power", range(0,1)) = 1
					_OShakeAmpX ("X-Axis Amp", float) = 4
					_OShakeAmpY ("Y-Axis Amp", float) = 8
					_OShakeFreqX ("X-Axis Freq", float) = 24
					_OShakeFreqY ("Y-Axis Freq", float) = 28
				[HideInInspector] m_end_OShake ("Shake", Float) = 0 // SHAKE

			[HideInInspector] m_end_Outline ("Outline", float) = 0


		[HideInInspector] m_end_Color ("Color", Float) = 0 // Color

		[HideInInspector] m_start_Shadertoy ("Shadertoy", Float) = 0 // Shadertoy
			[HideInInspector] m_start_Void ("Surface Of The Void", Float) = 0 // Void
				[Toggle()] SurfaceOfTheVoid ("Use Void", int) = 0
				[HideInInspector] m_start_UV ("UV", Float) = 0 // uv
					[NoScaleOffset]_VMainTex ("Noise", 2D) = "black" {}
					[Gamma]_VuvPower ("UV Power", range(0,1)) = 1
					_VzoomOut ("Zoom", Float) = 15
					_Vrotate ("Rotate", float) = 5
					[Vector2] _VXYScale("XY Scale", Vector) = (100, 50, 0, 0)
					[Vector3] _VXYMove("XYZ Move", Vector) = (0, -5, -22, 0)
					[Space(10)]
					_VupDown ("Up / Down", float) = 5.9
					_VleftRight ("Left / Right", float) = 0
					_Vdystroy ("Dystroy", float) = 0.4
					_Vhills("Hill Height", float) = 3
					_VHillAmount ("Hill Amount", float) = 0.8
					_VSmoothness ("Smoothness", float) = 10
					_VSpeed ("Speed", float) = 1
				[HideInInspector] m_end_UV ("UV", Float) = 0 // uv
				[HideInInspector] m_start_Color ("Coloring", Float) = 0 // Color
					[HDR] _VColor ("Color", Color) = (0,0.5,1,1.0)
					_SurfVignette ("Vignette", range(0,1)) = 0
					_VBrightness ("Brightness", float) = 0.
				[HideInInspector] m_end_Color ("Coloring", Float) = 0 // Color
			[HideInInspector] m_end_Void ("Surface Of The Void", Float) = 0 // Void

			[HideInInspector] m_start_Horror ("Horror Spiral", Float) = 0 // Horror
				[Toggle()] HorrorSpiral ("Use Horror Spiral", int) = 0
				[HideInInspector] m_start_movement ("Movement", Float) = 0
								//Shape
					_HZoom("Zoom", Range(0,3)) = 1
					_HspiralRot("Spiral Rotation Speed", Float) = 1
					_HspiralRotOffset("Spiral Rotation Offset", Float) = 0
					
					[Space(10)] // Camera
					_HZSpeed("Z Speed", Range(-5,5)) = 1
					_HZOff("Z Offset", Float) = 0
					[Space(10)] // Wobble
					[Toggle]_Hwobble("Wobble", Int) = 1
					_HwobAmount("Wobble Amount", Range(0,5)) = 1
					_HwobOffset("Wobble Offset", Float) = 0
				
				[HideInInspector] m_end_movement ("", Float) = 0
				//UV
				[HideInInspector] m_start_uv ("UV", Float) = 0
				[Enum(Left, 0, Right, 1, Cos, 2, Sin, 3)] _HROTTYPE("Rotation Type", Int) = 1
					[Vector2] _HXYMove ("Move", vector) = (0,0,0,0)
					[Vector2] _HXYScale ("Scale", vector) = (1,1,0,0)
					_HorrorMov ("Move Power", float) = 1
					_HspiralRotIter("Spiral Rotation Iterations", Range(-3,3)) = 1
					_HspiralIter("Spiral Iterations", Range(0,12)) = 3
					_HdistIter("Dist Iterations", Range(0,2)) = 1
					_Hedges("Edge Size", Range(0.5,5)) = 1
					_Hcomplex("Edge Complexity",Range(0,20)) = 3
					_HOffset("Offset", Range(0,1)) =1
					_Hthickness("Thickness", Float) = 0.9
				[HideInInspector] m_end_uv ("", Float) = 0
				//Coloring
				[HideInInspector] m_start_color ("Coloring", Float) = 0
					//alphas
					[HideInInspector] m_start_alpha ("Alphas", Float) = 0
						[Toggle]_HColorFix("Color Fix", Range(0,1)) = 0
						_HAlphaBG("BG Alpha", Range(-1,2)) = 1
						_HAlphaSpiral("Alpha", Range(-1,2)) = 1
						_Hgray ("Greyscale", Range(0,1)) = 0
							//vignette
						[Space(10)]
						_HorrorVignette ("Vignette", range(0,1)) = 0
					[HideInInspector] m_end_alpha ("", Float) = 0
				
				
					//color 1
					[HideInInspector] m_start_color1 ("Color 1", Float) = 0
						[HDR]_HColor1("Color", Color) = (0, 0, 0, 1)
						[HDR]_HColorMultiply("Color Multiply", Color) = (1., 1, 1,0)
						_HColorPow("Color Pow", Float) = 2.2
						_HColorSpeed ("Color Speed", Float) = 1
						_HColorOffset ("Color Offset", Float) = 0
						_HColorArea ("Color Area", Range(0,2)) = 1
							//hue 1
						[HideInInspector] m_start_hue1 ("Hue", Float) = 0
							[Toggle]_USEHUE_ON("Use Hue 1", int) = 0
							_Hueoffset("Hue 1 Offset", Float) = 1
							_Huespeed("Hue 1 Speed", Float) = 0
							
						[HideInInspector] m_end_hue1 ("", Float) = 0

					[HideInInspector] m_end_color1 ("", Float) = 0
							//Color 2
					[HideInInspector] m_start_color2 ("Color 2", Float) = 0
						[HDR]_HColor2("Color", Color) = (1, 0, 0, 1)
						_HSpiralColorSpeed ("Color Speed", Float) = 1
						_HSpiralColorOffset ("Color Offset", Float) = 0
						_HSpiralColorArea ("Color Area", Range(0,2)) = 1

								// hue 2
						[HideInInspector] m_start_hue2 ("Hue", Float) = 0
							[Toggle]_HUSEHUE_HON2("Use Hue 2", int) = 0
							_HHueoffset2("Hue 2 Offset", Float) = 1
							_HHuespeed2("Hue 2 Speed", Float) = 0
						[HideInInspector] m_end_hue2 ("", Float) = 0

					[HideInInspector] m_end_color2 ("", Float) = 0

				[HideInInspector] m_end_color ("", Float) = 0
			[HideInInspector] m_end_Horror ("Horror Spiral", Float) = 0 // Horror

			[HideInInspector] m_start_Voxel ("Voxel Tunnel", Float) = 0 // Voxel
				[Toggle()] _VoxelTunnelToggle ("Use Voxel Tunnel", int) = 0
                [HideInInspector] m_start_VoxUV ("UV", Float) = 0 // UV
                    [Vector3] _VoxelMovement ("Movement", vector) = (0,0,-5,0)
                    _VoxelZoom ("Zoom", float) = 1
                    _VoxelSpeed ("Speed", float) = 6
                    _VoxelSpeedOffset ("Speed Offset", float) = 0
                [HideInInspector] m_end_VoxUV ("UV", Float) = 0 // UV

                [HideInInspector] m_start_VoxCol ("Color", Float) = 0 // Color
                    _VoxelAlpha ("Alpha", range(0,1)) = 1
                    _VoxelVignette ("Vignette", range(0,1)) = 0
                    [HDR] _VoxMain ("Main Color", Color) = (.2, .2, .7, 1.)
                    [HDR] _VoxHighlights ("Main Highlights", Color) = (.2, .1, .2, 1.)
                    [HDR] _VoxRingCol ("Ring Color", Color) = (1., .0, .0, 1.)
                    
                [HideInInspector] m_end_VoxCol ("Color", Float) = 0 // Color
			[HideInInspector] m_end_Voxel ("Voxel Tunnel", Float) = 0 // Voxel

			[HideInInspector] m_start_NextrixSpiral ("Nextrix's Spiral", float) = 0
                [Toggle()] _NSpriToggle ("Use Spiral", int) = 0
                [HideInInspector] m_start_nSpriUV ("UV", Float) = 0 // uv
                    [Toggle()] _NSpriManual ("Manual Rotation", int) = 0
                    [Vector3] _NSpriMovement ("Movement", Vector) = (0,0,0,0)
                    _NSpriZoom ("Zoom", range(0,1)) = 1
                    _NSpriSpeed ("Speed", float) = 0.4
                    _NSpriSpeedOff ("Speed Offset", float) = 0
                    _NSpriRot ("Rotation", float) = 3
                    _NSpriShake ("Shake", float) = 0.35
                    _NSpriIterations ("Iterations", float) = 100
                    _NSpriDist ("View Distance", float) = 100
                    _NSpriOctaSize ("Octahedron Size", range(0,0.5)) = 0.15
                    _NSpriOffset ("Octahedron Offset", range(0.001,5)) = 0.25
                [HideInInspector] m_end_nSpriUV ("UV", Float) = 0 // uv
                
                [HideInInspector] m_start_nSpriColor ("Color", Float) = 0 // Color
                    _NSpriAlpha ("Alpha", range(0,1)) = 1
                    _NSpriPower ("Power", float) = 0.4
                    _NSpriVignette ("Vignette", range(0,1)) = 0
                    _NSpriColor ("Color", color) = (1,1,1,1)
                [HideInInspector] m_end_nSpriColor ("Color", Float) = 0 // Color

            [HideInInspector] m_end_NextrixSpiral ("Nextrix's Spiral", float) = 0


		[HideInInspector] m_end_Shadertoy ("Shadertoy", Float) = 0 // Shadertoy




		[HideInInspector] m_start_renderingSettings ("Rendering Settings", Float) = 0 //render
			[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 0
			[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 8
			[Enum(UnityEngine.Rendering.BlendMode)] _SourceBlend ("Source Blend", Float) = 5
			[Enum(UnityEngine.Rendering.BlendMode)] _DestinationBlend ("Destination Blend", Float) = 10
			[Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Int) = 0
			[HideInInspector]TileFactor("Tile XY / Offset ZW", vector) = (1,1,0,0)
			[Space(2)]
		[HideInInspector] m_end_renderingSettings ("Rendering Settings", Float) = 0 //render
        

	}
	CustomEditor "Thry.ShaderEditor"
	SubShader 
	{
		Tags { "Queue"="Overlay+4" "RenderType"="Overlay" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "PreviewType" = "None"}
		LOD 100
		ZWrite [_ZWrite]
		Cull [_Cull]
		ZTest [_ZTest]
		Blend [_SourceBlend] [_DestinationBlend]
		
		GrabPass { "_LoonaIsHot1" } // outline
		GrabPass { "_LoonaIsHot" } // effects

		Pass 
		{
			CGPROGRAM
			#pragma target 5.0
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert
			#pragma fragment frag

			#pragma skip_variants LIGHTMAP_ON DYNAMICLIGHTMAP_ON SHADOWS_SHADOWMASK SHADOWS_SCREEN LIGHTMAP_SHADOW_MIXING
			
			#define PI 3.14159265
			#define pi 3.14159265

			#define mod(x, y) (x-y* floor(x/y))
			#define iTime _Time.y
			#define mix lerp
			#define fract frac

			#define VoidULTRAVIOLET
            #define VoidDITHERING

            #define R(p, a) p=cos(a)*p+sin(a)*float2(p.y, -p.x)

            sampler2D _VMainTex;   float4 _VMainTex_TexelSize;
            sampler2D _LoonaIsHot1;
			#define textureLod(ch, uv, lod) tex2Dlod(ch, float4(uv, 0, lod))

			#include "UnityShaderVariables.cginc"
			#include "UnityCG.cginc"

			#include "Requires/cginc/Variables.cginc"
			#include "Requires/cginc/Vertex.cginc"
			#include "Requires/cginc/Grid.cginc"
			#include "Requires/cginc/Functions.cginc"
			#include "Requires/cginc/Shadertoy.cginc"
			#include "Requires/cginc/UV.cginc"

			
			ENDCG
		}
	}
}
