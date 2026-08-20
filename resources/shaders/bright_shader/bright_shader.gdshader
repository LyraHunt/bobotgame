shader_type canvas_item;

void fragment()
{
	COLOR.r = texture(TEXTURE, UV).r;
	//COLOR.r = 0.5;
}