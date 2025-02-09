shader_type canvas_item;
uniform vec2 pixelSize = vec2(12.0); // Block size for pixelation
uniform float edgeThreshold = 0.3; // Adjust sensitivity
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture, filter_linear_mipmap;

// Define the fixed color palette (converted from hex to normalized RGB)
const vec3 PALETTE[32] = vec3[](
    vec3(0.0, 0.0, 0.0),       // #000000
    vec3(0.133, 0.125, 0.203), // #222034
    vec3(0.270, 0.157, 0.235), // #45283c
    vec3(0.400, 0.224, 0.192), // #663931
    vec3(0.561, 0.337, 0.231), // #8f563b
    vec3(0.875, 0.443, 0.149), // #df7126
    vec3(0.851, 0.627, 0.400), // #d9a066
    vec3(0.933, 0.765, 0.604), // #eec39a
    vec3(0.984, 0.949, 0.212), // #fbf236
    vec3(0.600, 0.898, 0.314), // #99e550
    vec3(0.416, 0.745, 0.188), // #6abe30
    vec3(0.216, 0.580, 0.431), // #37946e
    vec3(0.294, 0.412, 0.184), // #4b692f
    vec3(0.322, 0.294, 0.141), // #524b24
    vec3(0.196, 0.235, 0.224), // #323c39
    vec3(0.247, 0.247, 0.455), // #3f3f74
    vec3(0.188, 0.376, 0.510), // #306082
    vec3(0.357, 0.431, 0.882), // #5b6ee1
    vec3(0.388, 0.608, 1.000), // #639bff
    vec3(0.373, 0.804, 0.894), // #5fcde4
    vec3(0.796, 0.859, 0.988), // #cbdbfc
    vec3(1.0, 1.0, 1.0),       // #ffffff
    vec3(0.608, 0.678, 0.718), // #9badb7
    vec3(0.518, 0.494, 0.529), // #847e87
    vec3(0.412, 0.416, 0.416), // #696a6a
    vec3(0.349, 0.337, 0.322), // #595652
    vec3(0.463, 0.259, 0.541), // #76428a
    vec3(0.675, 0.196, 0.196), // #ac3232
    vec3(0.851, 0.341, 0.388), // #d95763
    vec3(0.843, 0.482, 0.729), // #d77bba
    vec3(0.561, 0.592, 0.290), // #8f974a
    vec3(0.541, 0.435, 0.188)  // #8a6f30
);
// Function to find the closest color in the palette
vec3 find_nearest_color(vec3 color) {
    float minDist = 100000.0;
    vec3 closestColor = color;

    for (int i = 0; i < 32; i++) {
        float dist = distance(color, PALETTE[i]);
        if (dist < minDist) {
            minDist = dist;
            closestColor = PALETTE[i];
        }
    }

    return closestColor;
}

// Function to calculate brightness (luminance) of a color
float luminance(vec3 color) {
    return dot(color, vec3(0.299, 0.587, 0.114)); // Standard luma formula
}

void fragment() {
    vec2 screenTexSize = vec2(textureSize(SCREEN_TEXTURE, 0)); // Get screen texture size dynamically
    vec2 uv = floor(UV * screenTexSize / pixelSize) * pixelSize / screenTexSize;

    // Sample colors from the main pixel and adjacent ones
    vec3 color = texture(SCREEN_TEXTURE, uv).rgb;

    vec3 rightColor = texture(SCREEN_TEXTURE, uv + vec2(pixelSize.x / screenTexSize.x, 0)).rgb;
    vec3 bottomColor = texture(SCREEN_TEXTURE, uv + vec2(0, pixelSize.y / screenTexSize.y)).rgb;

    // Find nearest palette colors
    vec3 finalColor = find_nearest_color(color);
    vec3 rightFinalColor = find_nearest_color(rightColor);
    vec3 bottomFinalColor = find_nearest_color(bottomColor);
	//vec3 finalColor = color;
    //vec3 rightFinalColor = rightColor;
    //vec3 bottomFinalColor = bottomColor;


    // Compute luminance difference with neighbors
    float contrastRight = abs(luminance(finalColor) - luminance(rightFinalColor));
    float contrastBottom = abs(luminance(finalColor) - luminance(bottomFinalColor));

    // If contrast is high, draw black outline
    bool isEdge = contrastRight > edgeThreshold || contrastBottom > edgeThreshold;

    COLOR = isEdge ? vec4(0.0, 0.0, 0.0, 1.0) : vec4(finalColor, 1.0);
}
