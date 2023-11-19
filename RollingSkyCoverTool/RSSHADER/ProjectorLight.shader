// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'

Shader "Projector/Light" {
	Properties {
		_Color ("Main Color", Vector) = (1,1,1,1)
		_ShadowTex ("Cookie", 2D) = "" {}
		_FalloffTex ("FallOff", 2D) = "" {}
	}
	SubShader {
		Tags { "QUEUE" = "Transparent" }
		Pass {
			Tags { "QUEUE" = "Transparent" }
			Blend DstColor One, DstColor One
			ColorMask RGB
			ZWrite Off
			Offset -1, -1
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_Projector;
			float4x4 unity_ProjectorClip;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _ShadowTex;
			sampler2D _FalloffTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                o.texcoord = mul(unity_Projector, v.vertex);
				o.texcoord1 = mul(unity_ProjectorClip, v.vertex);
				o.position = UnityObjectToClipPos(v.vertex);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                fixed4 texS_1;
				fixed4 tmpvar_2;
				tmpvar_2 = tex2D (_ShadowTex, inp.texcoord);
				texS_1.xyz = (tmpvar_2.xyz * _Color.xyz);
				texS_1.w = (1.0 - tmpvar_2.w);
				fixed4 tmpvar_3;
				tmpvar_3 = (texS_1 * tex2D (_FalloffTex, inp.texcoord1).w);
				o.sv_target = tmpvar_3;
                return o;
			}
			ENDCG
		}
	}
}