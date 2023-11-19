// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/FrameDebuggerRenderTargetDisplay" {
Properties {
 _MainTex ("", any) = "white" { }
}
	//DummyShaderTextExporter
	
	SubShader{
		Tags { "ForceSupported"="true" }
		Pass {
			Tags { "ForceSupported"="true" }
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

			sampler2D _MainTex;
			fixed4 _Channels;
			half4 _Levels;

			// Keywords: 
			v2f vert(appdata_full v)
			{
				v2f o;
				float4 tmpvar_1;
				tmpvar_1.w = 1.0;
				tmpvar_1.xyz = v.vertex.xyz;
				o.position = UnityObjectToClipPos(tmpvar_1);
				o.texcoord = v.texcoord.xyz;
				return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
				fout o;
				half4 tex_1;
				fixed4 tmpvar_2;
				tmpvar_2 = tex2D (_MainTex, inp.texcoord.xy);
				tex_1 = tmpvar_2;
				fixed4 tmpvar_3;
				half4 col_4;
				col_4 = (tex_1 - _Levels.xxxx);
				col_4 = (col_4 / (_Levels.yyyy - _Levels.xxxx));
				col_4 = (col_4 * _Channels);
				float tmpvar_5;
				tmpvar_5 = dot (_Channels, float4(1.0, 1.0, 1.0, 1.0));
				if ((tmpvar_5 == 1.0)) {
				col_4 = (dot (col_4, float4(1.0, 1.0, 1.0, 1.0)));
				};
				tmpvar_3 = col_4;
				o.sv_target = tmpvar_3;
				return o;
			}
			ENDCG
		}
	}
}