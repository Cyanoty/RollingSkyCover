// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'

Shader "TurboChilli/Unlit/Textured/Basic" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		LOD 100
		Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "ALWAYS" "QUEUE" = "Geometry" }
		Pass {
			LOD 100
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "ALWAYS" "QUEUE" = "Geometry" }
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 color : COLOR0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float4 position : SV_POSITION0;
				UNITY_FOG_COORDS(3)
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                fixed4 tmpvar_1;
				half4 tmpvar_2;
				tmpvar_2 = clamp (float4(0.0, 0.0, 0.0, 1.1), 0.0, 1.0);
				tmpvar_1 = tmpvar_2;
				float4 tmpvar_3;
				tmpvar_3.w = 1.0;
				tmpvar_3.xyz = v.vertex.xyz;
				o.color = tmpvar_1;
				o.texcoord = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
				o.position = UnityObjectToClipPos(tmpvar_3);
				UNITY_TRANSFER_FOG(o,o.position);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                fixed4 tmpvar_1;
				tmpvar_1 = tex2D (_MainTex, inp.texcoord);
				o.sv_target = tmpvar_1;
				// apply fog
				UNITY_APPLY_FOG(inp.fogCoord, o.sv_target);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Mobile/Unlit (Supports Lightmap)"
}