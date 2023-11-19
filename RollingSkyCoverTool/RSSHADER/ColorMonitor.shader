// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TurboChilli/ColorMonitor" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_GreenIntensity ("Green Intensity", Float) = 1
		_MainColor ("Main Color", Vector) = (0,1,0,0)
		_BackgroundIntensity ("Background Intensity", Float) = 0.5
		_EffectIntensity ("Effect Intensity", Float) = 1
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
			float _BackgroundIntensity;
			float _EffectIntensity;
			float4 _MainColor;
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
                float2 uv_vector_1;
				float4 base_2;
				fixed4 tmpvar_3;
				tmpvar_3 = tex2D (_MainTex, inp.texcoord);
				base_2 = tmpvar_3;
				half2 tmpvar_4;
				tmpvar_4 = ((inp.texcoord * 2.0) - float2(1.0, 1.0));
				uv_vector_1 = tmpvar_4;
				float4 tmpvar_5;
				tmpvar_5.w = 0.0;
				tmpvar_5.xyz = ((base_2.xyz * _MainColor.xyz) + (((1.0 - 
				sqrt(dot (uv_vector_1, uv_vector_1))
				)) * (_BackgroundIntensity)));
				float4 tmpvar_6;
				tmpvar_6 = lerp (base_2, tmpvar_5, (_EffectIntensity));
				o.sv_target = tmpvar_6;
                return o;
			}
			ENDCG
		}
	}
}