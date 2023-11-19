// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "SF_EFFECTS/TransparentRim" {
	Properties {
		_RimColor ("Rim Color", Vector) = (0.5,0.5,0.5,0.5)
		_InnerColor ("Inner Color", Vector) = (0.5,0.5,0.5,0.5)
		_InnerColorPower ("Inner Color Power", Range(0, 1)) = 0.5
		_RimPower ("Rim Power", Range(0, 5)) = 2.5
		_AlphaPower ("Alpha Rim Power", Range(0, 8)) = 4
		_AllPower ("All Power", Range(0, 10)) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _RimColor;
			float _RimPower;
			float _AlphaPower;
			float _InnerColorPower;
			float _AllPower;
			float4 _InnerColor;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmpvar_1;
				tmpvar_1.w = 1.0;
				tmpvar_1.xyz = v.vertex.xyz;
				float4 v_2;
				v_2 = unity_WorldToObject[0];
				float4 v_3;
				v_3 = unity_WorldToObject[1];
				float4 v_4;
				v_4 = unity_WorldToObject[2];
				o.position = UnityObjectToClipPos(tmpvar_1);
				o.texcoord = normalize(((
				(v_2.xyz * v.normal.x)
				+ 
				(v_3.xyz * v.normal.y)
				) + (v_4.xyz * v.normal.z)));
				o.texcoord1 = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                fixed3 viewDir_1;
				fixed4 col_2;
				float3 tmpvar_3;
				tmpvar_3 = normalize((_WorldSpaceCameraPos - inp.texcoord1));
				viewDir_1 = tmpvar_3;
				fixed3 tmpvar_4;
				tmpvar_4 = normalize(viewDir_1);
				float tmpvar_5;
				tmpvar_5 = clamp (dot (tmpvar_4, inp.texcoord), 0.0, 1.0);
				float tmpvar_6;
				tmpvar_6 = (1.0 - tmpvar_5);
				float tmpvar_7;
				tmpvar_7 = pow (tmpvar_6, _RimPower);
				col_2.xyz = (((_RimColor.xyz * tmpvar_7) * _AllPower) + ((_InnerColor.xyz * 2.0) * _InnerColorPower));
				float tmpvar_8;
				tmpvar_8 = pow (tmpvar_6, _AlphaPower);
				col_2.w = (tmpvar_8 * _AllPower);
				o.sv_target = col_2;
                return o;
			}
			ENDCG
		}
	}
	Fallback "VertexLit"
}