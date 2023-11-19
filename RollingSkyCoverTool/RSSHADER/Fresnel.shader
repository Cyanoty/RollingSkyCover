// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TurboChilli/Unlit/Color/Fresnel" {
	Properties {
		_ColorE ("Core Color", Vector) = (1,1,1,1)
		_Color ("Mid Color", Vector) = (1,0.75,0,1)
		_ColorEAlt ("Rim  Color", Vector) = (1,0,0,1)
		_Ammount ("Ammount", Range(0, 1)) = 0.5
	}
	SubShader {
		LOD 200
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" }
		Pass {
			Name "FORWARDBASE"
			LOD 200
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry" "SHADOWSUPPORT" = "true" }
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float3 _Color;
			float3 _ColorE;
			float3 _ColorEAlt;
			float _Ammount;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmpvar_1;
				tmpvar_1.w = 0.0;
				tmpvar_1.xyz = v.normal;
				o.position = UnityObjectToClipPos(v.vertex);
				o.texcoord = mul(unity_ObjectToWorld, v.vertex);
				o.texcoord1 = mul(tmpvar_1, unity_WorldToObject).xyz;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                fixed4 tmpvar_1;
				float tmpvar_2;
				tmpvar_2 = dot (normalize(inp.texcoord1), normalize((_WorldSpaceCameraPos - inp.texcoord.xyz)));
				float tmpvar_3;
				tmpvar_3 = max (0.0, ((tmpvar_2 - _Ammount) / (1.0 - _Ammount)));
				float tmpvar_4;
				tmpvar_4 = min (max ((tmpvar_2 / _Ammount), 0.0), 1.0);
				float4 tmpvar_5;
				tmpvar_5.w = 1.0;
				tmpvar_5.xyz = (((_ColorEAlt * 
				(1.0 - (tmpvar_3 + tmpvar_4))
				) + (_Color * tmpvar_4)) + (_ColorE * tmpvar_3));
				tmpvar_1 = tmpvar_5;
				o.sv_target = tmpvar_1;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}