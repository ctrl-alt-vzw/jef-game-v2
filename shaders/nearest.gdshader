shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:hint_screen_texture, filter_linear_mipmap;
uniform float pixelSize = 4.0;

// Define the fixed color palette (converted from hex to normalized RGB)
//const vec3 PALETTE[32] = vec3[](
    //vec3(0.0, 0.0, 0.0),       // #000000
    //vec3(0.133, 0.125, 0.203), // #222034
    //vec3(0.270, 0.157, 0.235), // #45283c
    //vec3(0.400, 0.224, 0.192), // #663931
    //vec3(0.561, 0.337, 0.231), // #8f563b
    //vec3(0.875, 0.443, 0.149), // #df7126
    //vec3(0.851, 0.627, 0.400), // #d9a066
    //vec3(0.933, 0.765, 0.604), // #eec39a
    //vec3(0.984, 0.949, 0.212), // #fbf236
    //vec3(0.600, 0.898, 0.314), // #99e550
    //vec3(0.416, 0.745, 0.188), // #6abe30
    //vec3(0.216, 0.580, 0.431), // #37946e
    //vec3(0.294, 0.412, 0.184), // #4b692f
    //vec3(0.322, 0.294, 0.141), // #524b24
    //vec3(0.196, 0.235, 0.224), // #323c39
    //vec3(0.247, 0.247, 0.455), // #3f3f74
    //vec3(0.188, 0.376, 0.510), // #306082
    //vec3(0.357, 0.431, 0.882), // #5b6ee1
    //vec3(0.388, 0.608, 1.000), // #639bff
    //vec3(0.373, 0.804, 0.894), // #5fcde4
    //vec3(0.796, 0.859, 0.988), // #cbdbfc
    //vec3(1.0, 1.0, 1.0),       // #ffffff
    //vec3(0.608, 0.678, 0.718), // #9badb7
    //vec3(0.518, 0.494, 0.529), // #847e87
    //vec3(0.412, 0.416, 0.416), // #696a6a
    //vec3(0.349, 0.337, 0.322), // #595652
    //vec3(0.463, 0.259, 0.541), // #76428a
    //vec3(0.675, 0.196, 0.196), // #ac3232
    //vec3(0.851, 0.341, 0.388), // #d95763
    //vec3(0.843, 0.482, 0.729), // #d77bba
    //vec3(0.561, 0.592, 0.290), // #8f974a
    //vec3(0.541, 0.435, 0.188)  // #8a6f30
//);

const vec3 PALETTE[16] = vec3[](
    vec3(0.071, 0.035, 0.098),  // #120919
    vec3(0.106, 0.122, 0.294),  // #1b1f4b
    vec3(0.349, 0.161, 0.259),  // #592942
    vec3(0.063, 0.408, 0.212),  // #106836
    vec3(0.522, 0.290, 0.184),  // #854a2f
    vec3(0.302, 0.294, 0.267),  // #4d4b44
    vec3(0.643, 0.698, 0.749),  // #a4b2bf
    vec3(0.871, 0.933, 0.839),  // #deeed6
    vec3(0.816, 0.275, 0.282),  // #d04648
    vec3(0.929, 0.561, 0.231),  // #ed8f3b
    vec3(0.922, 0.851, 0.318),  // #ebd951
    vec3(0.380, 0.678, 0.212),  // #61ad36
    vec3(0.318, 0.565, 0.784),  // #5190c8
    vec3(0.467, 0.431, 0.529),  // #776e87
    vec3(0.890, 0.518, 0.635),  // #e384a2
    vec3(0.898, 0.733, 0.655)   // #e5bba7
);

// Function to find the closest color in the palette
vec3 find_nearest_color(vec3 color) {
    float minDist = 100000.0;
    vec3 closestColor = color;
    for (int i = 0; i < 16; i++) {
        float dist = distance(color, PALETTE[i]);
        if (dist < minDist) {
            minDist = dist;
            closestColor = PALETTE[i];
        }
    }
    return closestColor;
}


void fragment() {
    vec2 screenTexSize = vec2(textureSize(SCREEN_TEXTURE, 0)); // Get screen texture size dynamically
    vec2 uv = floor(UV * screenTexSize / pixelSize) * pixelSize / screenTexSize;

    vec4 color = texture(SCREEN_TEXTURE, uv);

    // Find the closest color in the palette
    vec3 finalColor = find_nearest_color(color.rgb);

    //COLOR = vec4(finalColor, color.a);
	COLOR = color;
}
