// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'

Shader "TurboChilli/Unlit/Textured/Offset/Lerped, Custom-Fog, G+10" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_AltTex ("Texture", 2D) = "white" {}
		_Ammount ("Lerp Weight", Range(0, 1)) = 0.5
		_ColorF ("Fog Color", Vector) = (0,0,0,1)
	}
	SubShader {
		LOD 200
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry+10" }
		Pass {
			LOD 200
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry+10" }
			Fog {
				Mode Off
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float2 texcoord : TEXCOORD0;
				float4 position : SV_POSITION0;
				float3 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorF;
			float _Ammount;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _AltTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float3 scrPos_1;
				float4 tmpvar_2;
				tmpvar_2 = UnityObjectToClipPos(v.vertex);
				float4 o_3;
				float4 tmpvar_4;
				tmpvar_4 = (tmpvar_2 * 0.5);
				float2 tmpvar_5;
				tmpvar_5.x = tmpvar_4.x;
				tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
				o_3.xy = (tmpvar_5 + tmpvar_4.w);
				o_3.zw = tmpvar_2.zw;
				scrPos_1.xy = o_3.xy;
				scrPos_1.z = clamp (((tmpvar_2.z * 0.075) - 1.25), 0.0, 1.0);
				o.texcoord = v.texcoord.xy;
				o.position = tmpvar_2;
				o.texcoord1 = scrPos_1;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                fixed4 tmpvar_1;
				fixed4 tmpvar_2;
				tmpvar_2 = lerp (tex2D (_MainTex, inp.texcoord), tex2D (_AltTex, inp.texcoord), _Ammount);
				float4 tmpvar_3;
				tmpvar_3 = lerp (tmpvar_2, _ColorF, inp.texcoord1.zzzz);
				tmpvar_1 = tmpvar_3;
				o.sv_target = tmpvar_1;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}