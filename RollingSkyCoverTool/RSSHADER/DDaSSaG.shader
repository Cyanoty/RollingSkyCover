// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'

Shader "TurboChilli/Lit/Diffuse (with Ambient) Specular (with Gloss and Ambient), Custom Fog" {
	Properties {
		_ColorD ("Diffuse Color", Vector) = (0.5,0,0,1)
		_ColorDa ("Diffuse Ambient Color", Vector) = (0,0,0.22,1)
		_ColorS ("Specular Color", Vector) = (1,1,1,1)
		_ColorSa ("Specular Ambient Color", Vector) = (0,0,0.185,1)
		_Gloss ("Gloss", Range(0, 1)) = 0
		_ColorF ("Fog Color", Vector) = (1,1,1,1)
		[Toggle] _AlphaAnim ("Alpha Anim", Float) = 0
		_Alpha ("Alpha", Float) = 1
		_AinmSpeed ("Anim Speed", Float) = 1
	}
	SubShader {
		LOD 200
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			LOD 200
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Fog {
				Mode Off
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
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
			float3 _ColorD;
			float3 _ColorS;
			float3 _ColorDa;
			float3 _ColorSa;
			float _Gloss;
			float3 _ColorF;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float3 scrPos_1;
				float4 tmpvar_2;
				tmpvar_2.w = 0.0;
				tmpvar_2.xyz = v.normal;
				float4 tmpvar_3;
				float4 tmpvar_4;
				tmpvar_4.w = 1.0;
				tmpvar_4.xyz = v.vertex.xyz;
				tmpvar_3 = UnityObjectToClipPos(tmpvar_4);
				float4 o_5;
				float4 tmpvar_6;
				tmpvar_6 = (tmpvar_3 * 0.5);
				float2 tmpvar_7;
				tmpvar_7.x = tmpvar_6.x;
				tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
				o_5.xy = (tmpvar_7 + tmpvar_6.w);
				o_5.zw = tmpvar_3.zw;
				scrPos_1.xy = o_5.xy;
				scrPos_1.z = clamp (((tmpvar_3.z * 0.075) - 1.25), 0.0, 1.0);
				o.position = tmpvar_3;
				o.texcoord = mul(unity_ObjectToWorld, v.vertex);
				o.texcoord1 = scrPos_1;
				o.texcoord2 = normalize(mul(tmpvar_2, unity_WorldToObject).xyz);
				UNITY_TRANSFER_FOG(o,o.position);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                fixed4 col_1;
				float3 tmpvar_2;
				tmpvar_2 = normalize(_WorldSpaceLightPos0.xyz);
				float3 tmpvar_3;
				tmpvar_3 = normalize(inp.texcoord2);
				float4 tmpvar_4;
				tmpvar_4.w = 1.0;
				tmpvar_4.xyz = lerp (((
				(((max (0.0, 
					dot (tmpvar_3, tmpvar_2)
				) * _LightColor0.xyz) + (glstate_lightmodel_ambient * 2.0).xyz) + _ColorDa)
				* _ColorD) + (
				((pow (max (0.0, 
					dot (tmpvar_3, normalize((normalize(
					(_WorldSpaceCameraPos - inp.texcoord.xyz)
					) + tmpvar_2)))
				), exp2(
					((_Gloss * 10.0) + 1.0)
				)) * _LightColor0.xyz) + _ColorSa)
				* _ColorS)), _ColorF, inp.texcoord1.zzz);
				col_1 = tmpvar_4;
				o.sv_target = col_1;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}