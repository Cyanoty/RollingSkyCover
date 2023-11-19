// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "RollingSky/Role/Other_Role" {
	Properties {
		_MainTex ("Baked Diffuse", 2D) = "white" {}
		_Specular ("Specular Level", Float) = 2
		_Gloss ("Gloss", Float) = 0.5
		_Color ("Specular Color", Vector) = (1,1,1,1)
		[Toggle] _AlphaAnim ("Alpha Anim", Float) = 0
		_Alpha ("Alpha", Float) = 1
		_AinmSpeed ("Anim Speed", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			ColorMask 0
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
				tmpvar_2 = clamp (v.color, 0.0, 1.0);
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
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float2 texcoord : TEXCOORD0;
				float4 position : SV_POSITION0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
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
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmpvar_1;
				tmpvar_1.w = 0.0;
				tmpvar_1.xyz = v.normal;
				float4 tmpvar_2;
				tmpvar_2.w = 1.0;
				tmpvar_2.xyz = v.vertex.xyz;
				o.texcoord = v.texcoord.xy;
				o.position = UnityObjectToClipPos(tmpvar_2);
				o.texcoord1 = mul(unity_ObjectToWorld, v.vertex);
				o.texcoord2 = normalize(mul(tmpvar_1, unity_WorldToObject).xyz);
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
                return o;
			}
			ENDCG
		}
	}
	Fallback "Specular"
}