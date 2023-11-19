// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TurboChilli/Unlit/Color/Debug" {
	Properties {
		_Color ("Main Color", Vector) = (0.5,0.5,0.5,0)
	}
	SubShader {
		LOD 200
		Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "ALWAYS" "QUEUE" = "Geometry" }
		Pass {
			LOD 200
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "ALWAYS" "QUEUE" = "Geometry" }
			Fog {
				Mode Off
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 color : COLOR0;
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _Color;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                fixed4 tmpvar_1;
				half4 tmpvar_2;
				tmpvar_2 = clamp (_Color, 0.0, 1.0);
				tmpvar_1 = tmpvar_2;
				float4 tmpvar_3;
				tmpvar_3.w = 1.0;
				tmpvar_3.xyz = v.vertex.xyz;
				o.color = tmpvar_1;
				o.position = UnityObjectToClipPos(tmpvar_3);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                o.sv_target = inp.color;
                return o;
			}
			ENDCG
		}
	}
}