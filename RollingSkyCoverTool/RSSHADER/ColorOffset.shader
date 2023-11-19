// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TurboChilli/ColorOffset" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_VertOffset ("Vertical Offset", Float) = 0.05
		_HoriOffset ("Horizontal Offset", Float) = 0.05
		_ColorDistance ("Distance between colors", Float) = 0.01
		_BlendEffect ("Intensity", Float) = 0.5
	}
	SubShader {
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			Fog {
				Mode Off
			}
			
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
			float _VertOffset;
			float _HoriOffset;
			float _ColorDistance;
			float _BlendEffect;
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
				tmpvar_1.w = 1.0;
				tmpvar_1.xyz = v.vertex.xyz;
				o.position = UnityObjectToClipPos(tmpvar_1);
				o.texcoord = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 base_1;
				float blue_sample_2;
				float green_sample_3;
				float red_sample_4;
				float2 tmpvar_5;
				tmpvar_5.x = _VertOffset;
				tmpvar_5.y = _HoriOffset;
				float2 P_6;
				P_6 = (inp.texcoord + tmpvar_5);
				fixed tmpvar_7;
				tmpvar_7 = tex2D (_MainTex, P_6).x;
				red_sample_4 = tmpvar_7;
				float2 P_8;
				P_8 = (inp.texcoord + (tmpvar_5 * _ColorDistance));
				fixed tmpvar_9;
				tmpvar_9 = tex2D (_MainTex, P_8).y;
				green_sample_3 = tmpvar_9;
				float2 P_10;
				P_10 = (inp.texcoord + ((tmpvar_5 * 2.0) * _ColorDistance));
				fixed tmpvar_11;
				tmpvar_11 = tex2D (_MainTex, P_10).z;
				blue_sample_2 = tmpvar_11;
				fixed4 tmpvar_12;
				tmpvar_12 = tex2D (_MainTex, inp.texcoord);
				base_1 = tmpvar_12;
				float4 tmpvar_13;
				tmpvar_13.w = 1.0;
				tmpvar_13.x = red_sample_4;
				tmpvar_13.y = green_sample_3;
				tmpvar_13.z = blue_sample_2;
				float4 tmpvar_14;
				tmpvar_14 = lerp (base_1, tmpvar_13, (_BlendEffect));
				o.sv_target = tmpvar_14;
                return o;
			}
			ENDCG
		}
	}
}