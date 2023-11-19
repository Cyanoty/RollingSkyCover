// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TurboChilli/Unlit/Textured/OLD - Overlayed Grid" {
	Properties {
		_MainTex ("First Texture", 2D) = "white" {}
		_Color ("Overlay Color", Vector) = (1,1,1,0.75)
		_Ammount ("Ammount", Range(0, 1)) = 0.5
		_Size ("Pulse Size", Float) = 10
		_SizeX ("Grid Size X", Float) = 10
		_SizeY ("Grid Size Y", Float) = 10
	}
	SubShader {
		LOD 200
		Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "ALWAYS" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			LOD 200
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "ALWAYS" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
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
			float4 _Color;
			float _Ammount;
			float _Size;
			float _SizeX;
			float _SizeY;
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
                fixed4 tmpvar_1;
				tmpvar_1 = tex2D (_MainTex, inp.texcoord);
				float tmpvar_2;
				tmpvar_2 = (floor((
				abs(((inp.texcoord.x - 0.5) * 2.0))
				* _SizeX)) / _SizeX);
				float tmpvar_3;
				tmpvar_3 = (floor((
				abs(((inp.texcoord.y - 0.5) * 2.0))
				* _SizeY)) / _SizeY);
				float4 tmpvar_4;
				tmpvar_4 = lerp (tmpvar_1, _Color, (max (0.0, (
				floor((((
					(tmpvar_2 * tmpvar_2)
					+ 
					(tmpvar_3 * tmpvar_3)
				) + (
					(_Ammount - 0.6)
					* 2.7)) * _Size))
				/ _Size))));
				o.sv_target = tmpvar_4;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Unlit/Texture"
}