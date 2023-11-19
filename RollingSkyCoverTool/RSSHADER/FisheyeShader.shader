// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/FisheyeShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
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
			float2 intensity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                half2 tmpvar_1;
				tmpvar_1 = v.texcoord.xy;
				float2 tmpvar_2;
				tmpvar_2 = tmpvar_1;
				o.position = UnityObjectToClipPos(v.vertex);
				o.texcoord = tmpvar_2;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                half4 color_1;
				half2 realCoordOffs_2;
				half2 coords_3;
				coords_3 = inp.texcoord;
				coords_3 = ((coords_3 - 0.5) * 2.0);
				realCoordOffs_2.x = (((1.0 - 
				(coords_3.y * coords_3.y)
				) * intensity.y) * coords_3.x);
				realCoordOffs_2.y = (((1.0 - 
				(coords_3.x * coords_3.x)
				) * intensity.x) * coords_3.y);
				fixed4 tmpvar_4;
				float2 P_5;
				P_5 = (inp.texcoord - realCoordOffs_2);
				tmpvar_4 = tex2D (_MainTex, P_5);
				color_1 = tmpvar_4;
				o.sv_target = color_1;
                return o;
			}
			ENDCG
		}
	}
}