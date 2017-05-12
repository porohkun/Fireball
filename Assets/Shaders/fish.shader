Shader "Effect/Fish"
{
    Properties
    {
        _MainTex("Sprite Texture", 2D) = "white" {}
        _Color("Tint", Color) = (1,1,1,1)
        _Scale("Scale", Float) = 12.0
		_Offset("Offset", Float) = 45.0
		[PerRendererData]
        _XOffset("X Offset", Float) = 0.0
		[PerRendererData]
		_YOffset("Y Offset", Float) = 0.0
    }

    SubShader
    {
        Tags
        {
        "RenderType" = "Opaque"
        "Queue" = "Transparent+1"
        }

		GrabPass
		{
			"_GrabTexture"
		}

        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile DUMMY PIXELSNAP_ON

            sampler2D _MainTex;
            fixed4 _Color;
            half _Scale;
			half _Offset;
			half _XOffset;
			half _YOffset;

            struct Vertex
            {
                float4 vertex : POSITION;
                float2 uv_MainTex : TEXCOORD0;
				float4 color    : COLOR;
            };

            struct Fragment
            {
                float4 vertex : SV_POSITION;
                half2 uv_MainTex : TEXCOORD0;
				fixed4 color : COLOR;
            };

            Fragment vert(Vertex v)
            {
                Fragment o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv_MainTex = v.uv_MainTex;
                o.color = v.color * _Color;

                return o;
            }

            fixed4 frag(Fragment i) :SV_Target
            {
                float2 t = i.uv_MainTex;
				float2 ct = (t - 0.5);

				float dist=sqrt(ct.x * ct.x + ct.y * ct.y);

				if (sqrt(ct.x * ct.x + ct.y * ct.y) > 0.5)
				    return 0;

				fixed4 realCoordOffs;
				float modd = ((dist*dist*dist*dist)+1/_Offset) * _Scale;

				float tx = ct.x * modd - _XOffset + 0.5;
                float ty = ct.y * modd - _YOffset + 0.5;

				if(tx >= 0)
				    tx = (tx - (int)tx);
				else
				    tx = 1-((int)tx - tx);

				if(ty >= 0)
                    ty = (ty - (int)ty);
				else
				    ty = 1-((int)ty - ty);
				//if (tx < 0) tx = 1 - tx;
				//if (ty < 0) ty = 1 - ty;
                //realCoordOffs.x = ct.x * modd + tx;
                //realCoordOffs.y = ct.y * modd + ty;
       
	            realCoordOffs.x = tx;
                realCoordOffs.y = ty;

                fixed4 color = tex2D (_MainTex,  realCoordOffs)* i.color;   
				//color.rgb*=color.a;
				return color;
            }

            ENDCG
        }
    }
    Fallback "Sprites/Default"
}