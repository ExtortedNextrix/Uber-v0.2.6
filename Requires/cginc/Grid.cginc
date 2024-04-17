            // Grid Vars
			int _GridType, _InvertGrid, _GridDistort;
			float _zoomOutGrid, _rotGrid, _sizeGrid;
			float2 _XYScaleGrid, _XYMoveGrid;

            
            float createSquare(float2 uvSquare){
				float size = 1 * 15;
				
				// rotate
				float ca = cos(radians(_rotGrid));
				float sa = sin(radians(_rotGrid));
				float2x2 rot = float2x2(ca, -sa, sa, ca);
				uvSquare.xy = mul(uvSquare, rot); 

                uvSquare *= _zoomOutGrid; // triangle uv controls
				uvSquare.xy = uvSquare.xy * _XYScaleGrid;
				uvSquare.xy = uvSquare.xy + _XYMoveGrid;

				//make Square
				float2 tiledUV = fract(uvSquare*size);
				float2 square = abs(tiledUV*2.-1.);
				float2 sharpSquare = step(_sizeGrid,square);
				float x = sharpSquare.x+sharpSquare.y;

				// invert
				float Square;
				UNITY_BRANCH if (_InvertGrid) {
					Square = smoothstep(_sizeGrid/1.1, _sizeGrid, x);
				} else {
					Square = smoothstep(_sizeGrid, _sizeGrid/1.1, x);
				}

				return Square;
			}

			float createTriangle(float2 uvTriangle) {

				// rotate
				float ca = cos(radians(_rotGrid));
				float sa = sin(radians(_rotGrid));
				float2x2 rot = float2x2(ca, -sa, sa, ca);
				uvTriangle.xy = mul(uvTriangle, rot); 

                uvTriangle *= _zoomOutGrid; // triangle uv controls
				uvTriangle.xy = uvTriangle.xy * _XYScaleGrid;
				uvTriangle.xy = uvTriangle.xy + _XYMoveGrid;

				
				//make triangle
				uvTriangle = mul(uvTriangle, float2x2(1,-1./1.73, 0,2./1.73));
				float3 g = float3(uvTriangle,1.-uvTriangle.x-uvTriangle.y);
				float3 _id = floor(g)+0.5;
				g = fract(g) * 10;
				float3 g2 = abs(2.*fract(g)-1.);
				float edge = max(max(g2.x,g2.y),g2.z);
				float2 x = float2((1.0-edge)*0.43, (1.0-edge)*0.43);

				// invert
				float tri;
                float triangleSize = _sizeGrid * 0.35;
				UNITY_BRANCH if (_InvertGrid) {
					tri = smoothstep(triangleSize, triangleSize/1.1, x);
				} else {
					tri = smoothstep(triangleSize/1.1, triangleSize, x);
				}
				

				return tri;
			}