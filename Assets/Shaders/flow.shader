Shader "Effect/Flow"
{
	Properties
	{
		[PerRendererData]

        _MainTex("Sprite Texture", 2D) = "white"{}

        _Color("Tint", Color) = (1,1,1,1)

        _XSpeed("X Speed (FPS)", Float) = 0

        _YSpeed("Y Speed (FPS)", Float) = 0

        _Tiling("Tiling", Float) = 1
	}

	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"RenderType" = "Transparent+1"
		}

		ZWrite Off

        Blend One OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            fixed4 _Color;

            half _XSpeed;
            half _YSpeed;
            half _Tiling;

            struct appdata_t
            {
                float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

            struct v2f
            {
                float4 vertex   : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord  : TEXCOORD0;
			};

            v2f vert(appdata_t IN)
            {
                v2f OUT;

                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.texcoord = IN.texcoord;
                OUT.color = IN.color * _Color;

                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
			{
				float2 uv = IN.texcoord;
                float timex = _Time.y * _XSpeed;
                float timey = _Time.y * _YSpeed;
                float tx = (timex - (int)timex) * _Tiling;
                float ty = (timey - (int)timey) * _Tiling;
                uv.x += tx;
				uv.y += ty;
				if (uv.x > _Tiling)
					uv.x -= _Tiling;
				if (uv.y > _Tiling)
					uv.y -= _Tiling;
				fixed4 color = tex2D(_MainTex, uv) * IN.color;
                color.rgb *= color.a;
				return color;
			}
			ENDCG
		}
	}
	Fallback "Sprites/Default"
}