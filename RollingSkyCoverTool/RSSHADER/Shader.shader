// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Fly_ball_Effect" {
	Properties {
		_tex_size01 ("tex_size01", Float) = -0.1
		_edgetex1_speed ("edgetex1_speed", Float) = 0.3
		_Tex01 ("Tex01", 2D) = "white" {}
		_tex_size02 ("tex_size02", Float) = -0.05
		_edgetex2_speed ("edgetex2_speed", Float) = 0.2
		_Tex02 ("Tex02", 2D) = "white" {}
		_field_size ("field_size", Range(0, 10)) = 7
		_field_edge_bright ("field_edge_bright", Float) = 0.6
		_field_edge_color ("field_edge_color", Vector) = (1,0.5,1,0.5)
		_buttom_color ("buttom_color", Vector) = (0,0.1,0.5,1)
		_top_color ("top_color", Vector) = (0.8,0.7,0.5,1)
		_AlPha ("AlPha", Range(0, 1)) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Cull Off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float _tex_size01;
			float _edgetex1_speed;
			float _tex_size02;
			float _edgetex2_speed;
			float4 _Tex01_ST;
			float4 _Tex02_ST;
			float _field_size;
			float _field_edge_bright;
			float4 _field_edge_color;
			float4 _buttom_color;
			float4 _top_color;
			float _AlPha;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Tex01;
			sampler2D _Tex02;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmpvar_1;
				tmpvar_1.w = 1.0;
				tmpvar_1.xyz = v.vertex.xyz;
				o.position = UnityObjectToClipPos(tmpvar_1);
				o.texcoord = v.texcoord.xy;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                float4 _Tex02_var_1;
				float4 _Tex01_var_2;
				float2 tmpvar_3;
				tmpvar_3 = ((inp.texcoord * 2.0) + -1.0);
				float4 tmpvar_4;
				tmpvar_4 = (_Time + _TimeEditor);
				float tmpvar_5;
				tmpvar_5 = sqrt(dot (tmpvar_3, tmpvar_3));
				float tmpvar_6;
				float tmpvar_7;
				tmpvar_7 = (min (abs(
				(tmpvar_3.y / tmpvar_3.x)
				), 1.0) / max (abs(
				(tmpvar_3.y / tmpvar_3.x)
				), 1.0));
				float tmpvar_8;
				tmpvar_8 = (tmpvar_7 * tmpvar_7);
				tmpvar_8 = (((
				((((
					((((-0.01213232 * tmpvar_8) + 0.05368138) * tmpvar_8) - 0.1173503)
					* tmpvar_8) + 0.1938925) * tmpvar_8) - 0.3326756)
				* tmpvar_8) + 0.9999793) * tmpvar_7);
				tmpvar_8 = (tmpvar_8 + (float(
				(abs((tmpvar_3.y / tmpvar_3.x)) > 1.0)
				) * (
				(tmpvar_8 * -2.0)
				+ 1.570796)));
				tmpvar_6 = (tmpvar_8 * sign((tmpvar_3.y / tmpvar_3.x)));
				if ((abs(tmpvar_3.x) > (1e-08 * abs(tmpvar_3.y)))) {
				if ((tmpvar_3.x < 0.0)) {
					if ((tmpvar_3.y >= 0.0)) {
					tmpvar_6 += 3.141593;
					} else {
					tmpvar_6 = (tmpvar_6 - 3.141593);
					};
				};
				} else {
				tmpvar_6 = (sign(tmpvar_3.y) * 1.570796);
				};
				float2 tmpvar_9;
				tmpvar_9.x = ((_tex_size01 * tmpvar_5) + (tmpvar_4.y * _edgetex1_speed));
				tmpvar_9.y = tmpvar_6;
				fixed4 tmpvar_10;
				float2 P_11;
				P_11 = ((tmpvar_9 * _Tex01_ST.xy) + _Tex01_ST.zw);
				tmpvar_10 = tex2D (_Tex01, P_11);
				_Tex01_var_2 = tmpvar_10;
				float2 tmpvar_12;
				tmpvar_12 = ((inp.texcoord * 2.0) + -1.0);
				float tmpvar_13;
				tmpvar_13 = sqrt(dot (tmpvar_12, tmpvar_12));
				float tmpvar_14;
				float tmpvar_15;
				tmpvar_15 = (min (abs(
				(tmpvar_12.y / tmpvar_12.x)
				), 1.0) / max (abs(
				(tmpvar_12.y / tmpvar_12.x)
				), 1.0));
				float tmpvar_16;
				tmpvar_16 = (tmpvar_15 * tmpvar_15);
				tmpvar_16 = (((
				((((
					((((-0.01213232 * tmpvar_16) + 0.05368138) * tmpvar_16) - 0.1173503)
					* tmpvar_16) + 0.1938925) * tmpvar_16) - 0.3326756)
				* tmpvar_16) + 0.9999793) * tmpvar_15);
				tmpvar_16 = (tmpvar_16 + (float(
				(abs((tmpvar_12.y / tmpvar_12.x)) > 1.0)
				) * (
				(tmpvar_16 * -2.0)
				+ 1.570796)));
				tmpvar_14 = (tmpvar_16 * sign((tmpvar_12.y / tmpvar_12.x)));
				if ((abs(tmpvar_12.x) > (1e-08 * abs(tmpvar_12.y)))) {
				if ((tmpvar_12.x < 0.0)) {
					if ((tmpvar_12.y >= 0.0)) {
					tmpvar_14 += 3.141593;
					} else {
					tmpvar_14 = (tmpvar_14 - 3.141593);
					};
				};
				} else {
				tmpvar_14 = (sign(tmpvar_12.y) * 1.570796);
				};
				float2 tmpvar_17;
				tmpvar_17.x = ((_tex_size02 * tmpvar_13) + (tmpvar_4.y * _edgetex2_speed));
				tmpvar_17.y = tmpvar_14;
				fixed4 tmpvar_18;
				float2 P_19;
				P_19 = ((tmpvar_17 * _Tex02_ST.xy) + _Tex02_ST.zw);
				tmpvar_18 = tex2D (_Tex02, P_19);
				_Tex02_var_1 = tmpvar_18;
				float tmpvar_20;
				tmpvar_20 = clamp (max ((
				(abs(((inp.texcoord.x * 2.0) + -1.0)) * 2.0)
				+ -1.0), (
				(abs(((inp.texcoord.y * 2.0) + -1.0)) * 2.0)
				+ -1.0)), 0.0, 1.0);
				float tmpvar_21;
				tmpvar_21 = ((_Tex01_var_2.x + _Tex02_var_1.x) * pow (tmpvar_20, _field_size));
				float tmpvar_22;
				tmpvar_22 = (tmpvar_21 * _field_edge_bright);
				float tmpvar_23;
				tmpvar_23 = (pow ((
				((((_Tex01_var_2.y + _Tex02_var_1.y) + (_Tex02_var_1.z * tmpvar_20)) + tmpvar_21) * tmpvar_20)
				* 0.5), 1.1) + tmpvar_22);
				float4 tmpvar_24;
				tmpvar_24.xyz = (lerp (_buttom_color.xyz, _top_color.xyz, tmpvar_23) + (tmpvar_22 * _field_edge_color.xyz));
				tmpvar_24.w = (tmpvar_23 * _AlPha);
				o.sv_target = tmpvar_24;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Off"
	CustomEditor "ShaderForgeMaterialInspector"
}