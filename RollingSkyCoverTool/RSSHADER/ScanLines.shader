// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TurboChilli/ScanLines" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_LineColor ("Line Color", Vector) = (1,1,1,1)
		_LineBlend ("Line Blend", Float) = 0.5
		_LineVertFreq ("Line Vertical Frequency", Float) = 1
		_VerticalOffset ("Line Vertical Offset", Float) = 1
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
			float4 _LineColor;
			float _LineBlend;
			float _LineVertFreq;
			float _VerticalOffset;
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
                float line0_1;
				float4 base_2;
				fixed4 tmpvar_3;
				tmpvar_3 = tex2D (_MainTex, inp.texcoord);
				base_2 = tmpvar_3;
				float tmpvar_4;
				tmpvar_4 = cos(((inp.texcoord.y * _LineVertFreq) + _VerticalOffset));
				line0_1 = tmpvar_4;
				float4 tmpvar_5;
				tmpvar_5 = lerp (base_2, (line0_1 * _LineColor), _LineBlend);
				o.sv_target = tmpvar_5;
                return o;
			}
			ENDCG
		}
	}
}