// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'

Shader "TurboChilli/Lit/Textured/Refractive and Reflective Gem Shader" {
	Properties {
		_ColorD ("Diffuse", Vector) = (1,1,1,1)
		_ColorS ("Specular", Vector) = (1,1,1,1)
		_ColorR ("Reflected Color", Vector) = (1,1,1,1)
		_Gloss ("Gloss", Range(0, 1)) = 0
		_ReflectTex ("Reflection Texture", Cube) = "dummy.jpg" {}
		_RefractTex ("Refraction Texture", Cube) = "dummy.jpg" {}
		_Refraction ("Refraction", Range(0, 1)) = 0.5
		_Opacity ("Opacity", Range(0, 1)) = 0.1
	}
	SubShader {
		Tags { "IgnoreProjector" = "true" "Queue" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IgnoreProjector" = "true" "LightMode" = "ForwardBase" "Queue" = "Transparent" "ShadowSupport" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			Cull Off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				UNITY_FOG_COORDS(5)
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float3 _ColorD;
			float3 _ColorS;
			float _Gloss;
			float _Refraction;
			float _Opacity;
			float3 _ColorR;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			samplerCUBE _RefractTex;
			samplerCUBE _ReflectTex;
			float4 _RefractTex_ST;
			float4 _ReflectTex_ST;

			CBUFFER_START(UnityProbeVolume)
			float4 unity_ProbeVolumeParams;
			float4x4 unity_ProbeVolumeWorldToObject;
			float3 unity_ProbeVolumeSizeInv;
			float3 unity_ProbeVolumeMin;
			CBUFFER_END

			UNITY_DECLARE_TEX3D_FLOAT(unity_ProbeVolumeSH);
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float3 shlight_1;
				fixed3 worldNormal_2;
				half3 tmpvar_3;
				half3 tmpvar_4;
				fixed3 tmpvar_5;
				float4 tmpvar_6;
				tmpvar_6.w = 1.0;
				tmpvar_6.xyz = v.vertex.xyz;
				float3 tmpvar_7;
				tmpvar_7 = (mul(unity_ObjectToWorld, v.vertex)).xyz;
				float4 v_8;
				v_8.xyzw = unity_WorldToObject[0].xyzw;
				float4 v_9;
				v_9.xyzw = unity_WorldToObject[1].xyzw;
				float4 v_10;
				v_10.xyzw = unity_WorldToObject[2].xyzw;
				float3 tmpvar_11;
				tmpvar_11 = normalize(((
				(v_8.xyz * v.normal.x)
				+ 
				(v_9.xyz * v.normal.y)
				) + (v_10.xyz * v.normal.z)));
				worldNormal_2 = tmpvar_11;
				tmpvar_4 = worldNormal_2;
				float3 tmpvar_12;
				float3 I_13;
				I_13 = (tmpvar_7 - _WorldSpaceCameraPos);
				tmpvar_12 = (I_13 - (2.0 * (
				dot (worldNormal_2, I_13)
				* worldNormal_2)));
				tmpvar_3 = tmpvar_12;
				fixed4 tmpvar_14;
				tmpvar_14.w = 1.0;
				tmpvar_14.xyz = worldNormal_2;
				half4 normal_15;
				normal_15 = tmpvar_14;
				half3 res_16;
				half3 x_17;
				x_17.x = dot (unity_SHAr, normal_15);
				x_17.y = dot (unity_SHAg, normal_15);
				x_17.z = dot (unity_SHAb, normal_15);
				half3 x1_18;
				half4 tmpvar_19;
				tmpvar_19 = (normal_15.xyzz * normal_15.yzzx);
				x1_18.x = dot (unity_SHBr, tmpvar_19);
				x1_18.y = dot (unity_SHBg, tmpvar_19);
				x1_18.z = dot (unity_SHBb, tmpvar_19);
				res_16 = (x_17 + (x1_18 + (unity_SHC.xyz * 
				((normal_15.x * normal_15.x) - (normal_15.y * normal_15.y))
				)));
				res_16 = max (((1.055 * 
				pow (max (res_16, float3(0.0, 0.0, 0.0)), float3(0.4166667, 0.4166667, 0.4166667))
				) - 0.055), float3(0.0, 0.0, 0.0));
				shlight_1 = res_16;
				tmpvar_5 = shlight_1;
				o.position = UnityObjectToClipPos(tmpvar_6);
				o.texcoord = tmpvar_3;
				o.texcoord1 = tmpvar_4;
				o.texcoord2 = tmpvar_7;
				o.texcoord3 = abs(v.normal);
				o.texcoord4 = tmpvar_5;
				UNITY_TRANSFER_FOG(o,o.position);
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
				fout o;
                fixed4 c_1;
				fixed3 tmpvar_2;
				fixed3 worldViewDir_3;
				fixed3 lightDir_4;
				float3 tmpvar_5;
				float3 tmpvar_6;
				half3 tmpvar_7;
				tmpvar_7 = _WorldSpaceLightPos0.xyz;
				lightDir_4 = tmpvar_7;
				float3 tmpvar_8;
				tmpvar_8 = normalize((_WorldSpaceCameraPos - inp.texcoord2));
				worldViewDir_3 = tmpvar_8;
				tmpvar_5 = inp.texcoord;
				tmpvar_6 = worldViewDir_3;
				tmpvar_2 = inp.texcoord1;
				fixed3 tmpvar_9;
				float tmpvar_10;
				float foreFacing_11;
				half faceDirection_12;
				float reflection_13;
				float refraction_14;
				fixed tmpvar_15;
				tmpvar_15 = texCUBE (_RefractTex, tmpvar_5).x;
				refraction_14 = tmpvar_15;
				fixed tmpvar_16;
				tmpvar_16 = texCUBE (_ReflectTex, tmpvar_5).x;
				reflection_13 = tmpvar_16;
				float tmpvar_17;
				tmpvar_17 = dot (normalize(tmpvar_6), tmpvar_2);
				faceDirection_12 = tmpvar_17;
				half tmpvar_18;
				tmpvar_18 = max (0.0, -(faceDirection_12));
				half tmpvar_19;
				tmpvar_19 = max (0.0, faceDirection_12);
				foreFacing_11 = tmpvar_19;
				float tmpvar_20;
				tmpvar_20 = ((tmpvar_18 * max (0.0, 
				(1.0 - _Refraction)
				)) + foreFacing_11);
				tmpvar_9 = (_ColorD + (_ColorR * (
				(reflection_13 + refraction_14)
				* tmpvar_20)));
				float tmpvar_21;
				tmpvar_21 = max (_Opacity, tmpvar_20);
				tmpvar_10 = tmpvar_21;
				c_1.w = 0.0;
				c_1.xyz = (tmpvar_9 * inp.texcoord4);
				half4 tmpvar_22;
				half3 lightDirection_23;
				lightDirection_23 = lightDir_4;
				half3 viewDirection_24;
				viewDirection_24 = worldViewDir_3;
				half tmpvar_25;
				tmpvar_25 = max (0.0, dot (tmpvar_2, lightDirection_23));
				half tmpvar_26;
				tmpvar_26 = max (0.0, dot (tmpvar_2, normalize(
				(lightDirection_23 + viewDirection_24)
				)));
				float4 tmpvar_27;
				tmpvar_27.xyz = (((
				(tmpvar_25 * tmpvar_9)
				+ 
				(pow (tmpvar_26, exp2((
					(_Gloss * 10.0)
					+ 1.0))) * _ColorS)
				) * _LightColor0.xyz) * 2.0);
				tmpvar_27.w = tmpvar_10;
				tmpvar_22 = tmpvar_27;
				c_1.xyz = (c_1 + tmpvar_22).xyz;
				c_1.w = 1.0;
				o.sv_target = c_1;
				// apply fog
				UNITY_APPLY_FOG(inp.fogCoord, o.sv_target);
                return o;
			}
			ENDCG
		}
	}
}