// Surface of the void

    float pn(in float3 p)
    {
        float3 ip = floor(p);
        p = frac(p);
        p *= p * (3. - 2. * p);
        float2 uv = ip.xy + float2(37., 17.) * ip.z + p.xy;
        uv = textureLod(_VMainTex, (uv + 0.5) / 256., 0.).yx;
        return lerp(uv.x, uv.y, p.z);
    } 

    float fpn(float3 p)
    {
        return pn(p * 0.06125) * 0.57 + pn(p * 0.125) * 0.28 + pn(p * 0.25) * 0.15;
    }

    float rand(float2 co)
    {
        return frac(sin(dot(co * 0.123, float2(12.9898, 78.233))) * 43758.547);
    }

    float cosNoise(in float2 p)
    {
        return 0.5 * (sin(p.x) + sin(p.y));
    }

    static const float2x2 m2 = transpose(float2x2(1.6, -1.2, 1.2, 1.6));
    float sdTorus(float3 p, float2 t)
    {
        return length(float2(length(p.xz) - t.x * 1.2, p.y)) - t.y;
    }

    float smin(float a, float b, float k)
    {
        float h = clamp(0.5 + 0.5 * (b - a) / k, 0., 1.);
        return lerp(b, a, h) - k * h * (1. - h);
    }

    float SunSurface(in float3 pos)
    {
        float h = 0.;
        float2 q = pos.xz * _VHillAmount;
        float s = 0.5;
        float d2 = 0.;
        for (int i = 0; i < _VSmoothness; i++)
        {
            h += s * cosNoise(q);
            q = mul(m2,q) * 0.85;
            q += float2(2.41, 8.13);
            s *= 0.48 + _Vdystroy * h;
        }
        h *= _Vhills;
        float d1 = pos.y - h;
        float3 r1 = mod(2.3 + pos + 1., 10.) - 5.;
        r1.y = pos.y - 0.1 - 0.7 * h + 0.5 * sin(3. * iTime + pos.x + 3. * pos.z);
        float c = cos(pos.x);
        float s1 = 1.;
        r1.xz = c * r1.xz + s1 * float2(r1.z, -r1.x);
        d2 = sdTorus(r1.xzy, float2(clamp(abs(pos.x / pos.z), 0.7, 2.5), 0.2));
        return smin(d1, d2, 1.);
    }

    float Vmap(float3 p)
    {
        p.z += 1.;
        R(p.yz, _VupDown);
        R(p.xz, _VleftRight.x * 0.008 * pi + iTime * 0.07 * _VSpeed);
        return (SunSurface(p * 1.777) + fpn(p * 2.777 + iTime * 1.777) * 4.777 - fpn(p * 100. + iTime * -70.) * 0.5 - 1.) * 0.777;
    }

    float3 firePalette(float i)
    {
        float T = 1400. + 1300. * i;
        float3 L = float3(7.4, 5.6, 4.4);
        L = pow(L, ((float3)5.)) * (exp(143876.72 / (T * L)) - 1.);
        return 1. - exp(-1000000000. / L);
    }

    float4 CreateVoid (float2 uv) {
        uv.xy = mul(uv, r2d(_Vrotate));

        uv *= _VzoomOut;
        uv.xy = uv.xy * _VXYScale;
        uv.xy = uv.xy + _VXYMove;


        float4 col = float4(0,0,0,1);
        // p: position on the ray
        // rd: direction of the ray
        float3 rd = normalize(float3((uv-0.5*_ScreenParams.xy)/_ScreenParams.y, 1.));
        float3 ro = float3(_VXYMove.xyz);
        
        // ld, td: local, total density 
        // w: weighting factor
        float ld=0., td=0., w=0.;

        // t: length of the ray
        // d: distance function
        float d=1., t=1.;
        
        // Distance threshold.
        const float h = .2;
            
        // total color
        float3 tc = float(_VBrightness);
        
        #ifdef VoidDITHERING
        float2 pos = ( uv.xy / _ScreenParams.xy );
        float2 seed = pos + fract(iTime);
        t=(1.+0.2*rand(seed));
        #endif
            
        // rm loop
        for (int i=0; i<56; i++) {

            // Loop break conditions. Seems to work, but let me
            // know if I've overlooked something.
            if(td>(1.-1./80.) || d<0.001*t || t>40.)break;
            
            // evaluate distance function
            d = Vmap(ro+t*rd); 
            
            // fix some holes deep inside
            d=max(d,-.3);
            
            // check whether we are close enough (step)
            // compute local density and weighting factor 
            const float h = .1;
            ld = (h - d) * step(d, h);
            w = (1. - td) * ld;   
            
            // accumulate color and density
            tc += w*w + 1./50.;  // Different weight distribution.
            td += w + 1./200.;

            // dithering implementation come from Eiffies' https://www.shadertoy.com/view/MsBGRh
            #ifdef VoidDITHERING  
            #ifdef VoidULTRAVIOLET
            // enforce minimum stepsize
            d = max(d, 0.04);
            // add in noise to reduce banding and create fuzz
            d=abs(d)*(1.+0.28*rand(seed*float(i)));
            #else
            // add in noise to reduce banding and create fuzz
            d=abs(d)*(.8+0.28*rand(seed*float(i)));
            // enforce minimum stepsize
            d = max(d, 0.04);
            #endif 
            #else
            // enforce minimum stepsize
            d = max(d, 0.04);        
            #endif

            // step forward
            t += d*0.5;
            
        }

        // Fire palette.
        tc = firePalette(tc.x);
        
        #ifdef VoidULTRAVIOLET
        tc *= 1. / exp( ld * 2.82 ) * 1.05;
        #endif
            
        col = float4(sqrt(tc), 1.0);
        col = float4(((float3)(col.r + col.g + col.b) / 3.0), 1.0);
        col *= col * col;
        col *= float4(_VColor);

        return col * _VuvPower;
    }

//Horror       
    float2x2 Hr2d(float a) {
        float leftc, rightc, cosc, sinc; // Cos
        float lefts, rights, coss, sins; // Sin
        switch(_HROTTYPE) {
            case 0:	
                leftc = cos(a), lefts = sin(a);
                return float2x2(leftc, lefts, -lefts, leftc);
        
            case 1: 
                rightc = sin(a), rights = cos(a);
                return float2x2(rightc, rights, -rights, rightc);
        
            case 2:	
                cosc = cos(a), coss = cos(a);
                return float2x2(cosc, coss, -coss, cosc);
            case 3:
                sinc = sin(a), sins = sin(a);
                return float2x2(sinc, sins, -sins, sinc);
        }
        return float2x2(a, a, -a, a);
    }

    float mod1(float x, float y)
    {
        return x - y * floor(x / y);
    }
    float2 mod1(float2 x, float2 y)
    {
        return x - y * floor(x / y);
    }
    float3 mod1(float3 x, float3 y)
    {
        return _HOffset*(x - y * floor(x / y));
    }
    float4 mod1(float4 x, float4 y)
    {
    return x - y * floor(x / y);
    }


    float Hde(float3 p) {

        //p.y += _Hwobble*cos(_Time.y*2.) * .2;

        p.y += ((_HXYMove.y / (3.50 + _HorrorMov)) * _HorrorMov) + _Hwobble * cos(iTime*2.) * .2; //new
        p.x += ((_HXYMove.x / (1.07 + _HorrorMov)) * _HorrorMov) + _Hwobble * sin(iTime*2.) * .0; //new
        p.xy = mul(Hr2d(_HspiralRotOffset+_Time.y*_HspiralRot + p.z * _HspiralRotIter),p.xy);

        float3 r;
        float d = 0., s = 1.;
        for (int i = 0; i < _HspiralIter; i++)
            r = max(r = abs(mod1(p*s + 1, 2) - 1.), r.yzx)*_Hedges,
            d = max(d, (_Hthickness - min(r.x, min(r.y, r.z))) / s),
            s *= _Hcomplex;

        return d;
    }

    float4 CreateHorrorSpiral( float2 uv ) {
        float4 uvCol = float(0);
        uv = uv - 0.5;
        uv.x *= _ScreenParams.x / _ScreenParams.y;
        uv.xy = uv.xy * _HXYScale;
        uv.xy = uv.xy + _HXYMove;

        //shadertoy https://www.shadertoy.com/view/4tlBWX
        //uv += float2(_HXYMove);
        float3 ro = float3(.1*cos(_Time.y+_HwobOffset)*_HwobAmount, 0, -_Time.y*_HZSpeed+_HZOff), p;
        float3 rd = normalize(float3(uv, _HZoom));
        p = ro;

        float it = 0.;
        float d= 0;
            for (float i=0.; i < _HdistIter; i += .01) {
            it = i;
            d = Hde(p);
            if (d < .001) break;
            p += rd * d*.4;
        }
        it /= (_HSpiralColorArea+0.0001)*.4 * sqrt(abs(tan(_Time.y*_HSpiralColorSpeed+_HSpiralColorOffset) + p.x*p.x + p.y*p.y));
        float3 c = float3(0,0,0);
            if (_HUSEHUE_HON != 0)
        {
            float3 rgbTohsv = RGBToHSV(_HColor1.rgb);
            float3 hsvTorgb = HSVToRGB(float3(_HHueoffset + (_Time.y * _HHuespeed), rgbTohsv.y, rgbTohsv.z));
            _HColor1.rgb = hsvTorgb;

        }

            if (_HUSEHUE_HON2 != 0)
        {
            float3 rgbTohsv = RGBToHSV(_HColor2.rgb);
            float3 hsvTorgb = HSVToRGB(float3(_HHueoffset2 + (_Time.y * _HHuespeed2), rgbTohsv.y, rgbTohsv.z));
            _HColor2.rgb = hsvTorgb;
        }
        c = lerp(_HColor1, _HColor2, _HColorArea*it*sin(p.z+_Time.y*_HColorSpeed+_HColorOffset));
        //c = lerp(0, 1, smoothstep(0.4,1,d));
        c = lerp(c,dot(c,0.333),_Hgray)*_HColorMultiply;
        
        uvCol += float4(pow(clamp(c,-3*_HColorFix,2),_HColorPow) * _HAlphaSpiral, _HAlphaBG);
        return uvCol;
    }


//voxel tunnel
    float2 Voxelpath(float t) {
        float a = sin(t*.2 + 1.5), b = sin(t*.2);
        return float2(2.*a, a*b);
    }

    float g = 0.;
    float Voxelde(float3 p) {
        p.xy -= Voxelpath(p.z);

        float d = -length(p.xy) + 4.;// tunnel (inverted cylinder)

        p.xy += float2(cos(p.z + iTime)*sin(iTime), cos(p.z + iTime));
        p.z -= 6. + iTime * 6.;
        d = min(d, dot(p, normalize(sign(p))) - 1.); // octahedron (LJ's formula)
        // I added this in the last 1-2 minutes, but I'm not sure if I like it actually!

        // Trick inspired by balkhan's shadertoys.
        // Usually, in raymarch shaders it gives a glow effect,
        // here, it gives a colors patchwork & transparent voxels effects.
        g += .015 / (.01 + d * d);
        return d;
    }


    float4 CreateVoxel(float2 uv)
    {
        uv = uv - 0.5;
        uv.x *= _ScreenParams.x / _ScreenParams.y;
        uv *= _VoxelZoom;
        float4 finalCol = float4(0,0,0,1);


        float dt = iTime * _VoxelSpeed + _VoxelSpeedOffset;
        //float dt = iTime * 6.;
        float3 ro = float3(float2(_VoxelMovement.xy), _VoxelMovement.z + dt);
        float3 ta = float3(0, 0, dt);

        ro.xy += Voxelpath(ro.z);
        ta.xy += Voxelpath(ta.z);

        float3 fwd = normalize(ta - ro);
        float3 right = cross(fwd, float3(0, 1, 0));
        float3 up = cross(right, fwd);
        float3 rd = normalize(fwd + uv.x*right + uv.y*up);

        rd.xy = mul(rd.xy, r2d(sin(-ro.x / 3.14)*.3));

        float3 p = floor(ro) + .5;
        float3 mask;
        float3 drd = 1. / abs(rd);
        rd = sign(rd);
        float3 side = drd * (rd * (p - ro) + .5);

        float t = 0., ri = 0.;
        for (float i = 0.; i < 1.; i += .01) {
            ri = i;
            if (Voxelde(p) < 0.) break;
            mask = step(side, side.yzx) * step(side, side.zxy);
            side += drd * mask;
            p += rd * mask;
        }
        t = length(p - ro);
        
        float3 c = float3(1,1,1) * length(mask * float3(1., .5, .75));
        c = mix(float3(_VoxMain.rgb), float3(_VoxHighlights.rgb), c);
        c += g * .4;
        float ringMath = sin(iTime)*.2 + sin(p.z*.5 - iTime * 6.);
        c.r += lerp(c.r, ringMath, _VoxRingCol.r);
        c.g += lerp(c.g, ringMath, _VoxRingCol.g);
        c.b += lerp(c.b, ringMath, _VoxRingCol.b);

        c = lerp(c, _VoxHighlights.rgb, 1. - exp(-.001*t*t));// fog
        finalCol = float4(clamp(c*c, 0., 1.),1);
        return float4(finalCol) * _VoxelAlpha;
    }

// Nextrix Spiral
    float3 palette(float t) {
        return .5+.5*cos(6.28318*(t+float3(.3,.416,.557)));
    }
    
    // Octahedron SDF - https://iquilezles.org/articles/distfunctions/
    float sdOctahedron(float3 p, float s) {
        p = abs(p);
        return (p.x+p.y+p.z-s)*0.57735027;
    }

    // Scene distance
    float NSprimap(float3 p) {
        p.z += iTime * _NSpriSpeed + _NSpriSpeedOff; // Forward movement
        
        // Space repetition
        p.xy = (fract(p.xy) - .5);   // spacing: 1
        p.z = mod(p.z, _NSpriOffset) - _NSpriOffset/2; // spacing: .25
        
        return sdOctahedron(p, _NSpriOctaSize); // Octahedron
    }

    float4 CreateNextrixSpiral(float2 uv)
    {  
        float4 col = float4(0,0,0,1);
        uv = uv - 0.5;
        uv.x *= _ScreenParams.x / _ScreenParams.y;
        float2 m = (uv.xy * 2. - _ScreenParams.xy) / _ScreenParams.y;
        
        if (_NSpriManual == 0) {
            m = float2(cos(iTime*.2), sin(iTime*.2));
        }

        float3 ro = _NSpriMovement.xyz;
        float3 rd = normalize(float3((uv), 1)); 
        float t = 0.; // total distance travelled

        int i; // Raymarching
        for (i = 0; i < _NSpriIterations; i++) {
            float3 p = ro + rd * t; // position along the ray
            
            p.xy = mul(p.xy, r2d(t*_NSpriRot * m.x));     // rotate ray around z-axis

            p.y += sin(t*(m.y+1.)*.5)*_NSpriShake;  // wiggle ray

            float d = NSprimap(p*_NSpriZoom);     // current distance to the scene

            t += d;               // "march" the ray

            if (d < .001 || t > _NSpriDist) break; // early stop
        }


        col.rgb = palette(t * (_NSpriPower / 100.) + float(i) * 0.05) * _NSpriColor.rgb;


        return float4(col);
    }




