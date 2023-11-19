// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Grayscale Effect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_RampTex ("Base (RGB)", 2D) = "grayscaleRamp" {}
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
			float _RampOffset;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _RampTex;
			
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
                fixed4 xlat_varoutput_1;
				float grayscale_2;
				fixed4 tmpvar_3;
				tmpvar_3 = tex2D (_MainTex, inp.texcoord);
				half3 c_4;
				c_4 = tmpvar_3.xyz;
				float tmpvar_5;
				tmpvar_5 = dot (c_4, unity_ColorSpaceLuminance.xyz);
				grayscale_2 = tmpvar_5;
				half2 tmpvar_6;
				tmpvar_6.y = 0.5;
				tmpvar_6.x = (grayscale_2 + _RampOffset);
				xlat_varoutput_1.xyz = tex2D (_RampTex, tmpvar_6).xyz;
				xlat_varoutput_1.w = tmpvar_3.w;
				o.sv_target = xlat_varoutput_1;
                return o;
			}
			ENDCG
		}
	}
}