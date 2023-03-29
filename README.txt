Josh Morgan (100824998)
*
*
*
Screenshots of Jaws Build: ICG Individual Assignment 2 -> ReadMe Files

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
*
*
*
Extra Shader to Scene:
	Bloom was implemented using the bloom scripts we created in class. The bloom effect script was attched to the camera, and the bloom shader was attached to the script in the inspector. One thing I changed in the camera script for the bloom effect was modifying the iterations over time using Lerping. I created a time variable for tracking when the iterations should go back down, as well as low and high variables to act as caps for the lerp to operate between (essentially, increase/decrease the iterations between the low and high variables by a value time). I also set time to work like a sin wave using the mathf.cos function so it runs more smoothly.

	Outlines were implemented using a similar method taught it class. Essentially it uses a second render pass of the object that doesn't use textures or surface variables. The default colour is black but the colour can be changed if need be. The shader culls the front faces so only the back faces are rendered behind the actual object, so the effect is an outline around the object. In order for the outline to not get rendered behind other objects, and only when there is nothing behind the object, zwrite is turned off and a stencil is used to set the comparison value to always instead of never.
*
*
*
Code Snippet 2 Explanation:
	This shader/code is used to effect the colour of a shadow that an object is producing (shadow colour variable is highlighted). The shadows are calculated using the diff variable and getting the max between 0 and the dot product between the surface normal and the light direction. The colour is then applied using the surface colour, the light colour, and the diff variable multiplied by the attenuation. The changed shadow colour is then added to the 'c' variable multiplied by attenuation. Then all of these variables are applied to the surface using the surf function.

	An example of where this could be used is in a game where meteors are falling from the sky and  the player has to avoid them. In order to signify the danger more, you could make the shadows of the meteors red since red is the colour most commonly associated with danger.
*
*
*
Shader of my choosing to explain:
	Glass Shader. The glass shader takes in a texture, and a bump map. The texel size and different uv values are needed in order to make portions of the surface see-through. The vertex and fragment functions takes the vertices from clip to world space and positions them on the screen. A tint value is used to create the transparent effect on the mesh/window by multiplying the colour from the texture by the provided colour. The bump map creates an offset on the mesh and can be manipulated by the scale variable. The bump map causes distortions no the mesh based on directional information. This shader can be used for car windows or stained glass in a church.

See diagram for glass shader: ICG Individual Assignment 2 -> ReadMe Files -> Glass Shader Diagram