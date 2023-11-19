// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TurboChilli/Lit/Textured/Baked Diffuse plus Directional Specular" {
	Properties {
		_MainTex ("Baked Diffuse", 2D) = "white" {}
		_Specular ("Specular Level", Float) = 2
		_Gloss ("Gloss", Float) = 0.5
		_Color ("Specular Color", Vector) = (1,1,1,1)
	}
	SubShader {
		Pass {
			Tags { "LIGHTMODE" = "FORWARDBASE" }
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float2 texcoord : TEXCOORD0;
				float4 position : SV_POSITION0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				UNITY_FOG_COORDS(3)
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float _Specular;
			float _Gloss;
			float3 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmpvar_1;
				tmpvar_1.w = 0.0;
				tmpvar_1.xyz = v.normal;
				o.texcoord = v.texcoord.xy;
				o.position = UnityObjectToClipPos(v.vertex);
				o.texcoord1 = mul(unity_ObjectToWorld, v.vertex);
				o.texcoord2 = normalize(mul(tmpvar_1, unity_WorldToObject).xyz);
				UNITY_TRANSFER_FOG(o,o.position);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmpvar_1;
				fixed4 col_2;
				float3 specularReflection_3;
				float3 tmpvar_4;
				tmpvar_4 = normalize(inp.texcoord2);
				float3 tmpvar_5;
				tmpvar_5 = normalize((_WorldSpaceCameraPos - inp.texcoord1.xyz));
				float3 tmpvar_6;
				tmpvar_6 = normalize(_WorldSpaceLightPos0.xyz);
				float tmpvar_7;
				tmpvar_7 = dot (tmpvar_4, tmpvar_6);
				if ((tmpvar_7 < 0.0)) {
				specularReflection_3 = float3(0.0, 0.0, 0.0);
				} else {
				float3 I_8;
				I_8 = -(tmpvar_6);
				specularReflection_3 = (_LightColor0.xyz * pow (max (0.0, 
					dot ((I_8 - (2.0 * (
					dot (tmpvar_4, I_8)
					* tmpvar_4))), tmpvar_5)
				), _Gloss));
				};
				fixed4 tmpvar_9;
				tmpvar_9 = tex2D (_MainTex, inp.texcoord);
				float4 tmpvar_10;
				tmpvar_10.w = 1.0;
				tmpvar_10.xyz = (tmpvar_9.xyz + ((specularReflection_3 * _Specular) * _Color));
				col_2 = tmpvar_10;
				tmpvar_1 = col_2;
				o.sv_target = tmpvar_1;
				// apply fog
				UNITY_APPLY_FOG(inp.fogCoord, o.sv_target);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Specular"
}