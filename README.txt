Josh Morgan (100824998)
*
*
*
Forward Rendering:
	The forward rendering approach first renders all the objects/models and geometry in the scene, processes the vertex/geometry shaders for each geometry, and applies lighting. Each object is rendered a number of times depending on the number of lighting models in the scene (rendered 5 times with each light if there are 5 lights).

See Diagram for For Forward Rendering: ICG Individual Assignment 2 -> ReadMe Files -> Forward Rendering Diagram

Deferred Rendering:
	Compared to Forward Rendering where objects/geometry go through the pipeline once at a time to produce the final image, Deferred Rendering instead passes each object through the pipeline and doesn't apply lighting until all objects/geometry are rendered.

See Diagram for For Deferred Rendering: ICG Individual Assignment 2 -> ReadMe Files -> Deferred Rendering Diagram
*
*
*
Square Toon Shaded Wave:
	To do this I implemented the toon shader code into the water shader by setting the surf to ToonRamp instead of Lambert, and inserted the lighting model. In order to get the wave in a square-shape, I set the second sin wave function for waveHeight to v.vertex.z instead of v.vertex.x again, and I also added waveHeight to v.normal.z in the v.normal variable. As for changes in the toon shading, I divide the default ramp texture by a more detailed ramp texture. The result are shadow-like highlights around the higher points in the wave.

Jaws Scene Recreation:
	To recreate this scene I placed the camera above the environment and faced it downwards to replicate the top-down style, and I added primitive shapes (cubes) to the scene and blocked out the visible landscape with the water plane below. I also turned off shadows on the directional light to stop the shadows of the landscape being casted onto the water.
*
*
*
Code Snippet 1 Explanation:
	The first 4 highlighted lines of the code tell me that this is something that is being rendered on to the camera view. The "source.width" and "source.height" applied to the width and height variables suggest this code is gathering the resolution of the viewport. The "RenderTexture" variables and "Graphics.Blit" functions around the code suggest a texture or shader is applied to the camera to change how the scene looks are that something is applied. For instance, if the user wants some sort of texture applied to only certain parts of the scene (lighter areas for example), they would use this code, and this is designated by the decision making in this code.