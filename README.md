Here in folders are all my sketches. From my Gaudi star, to the experiments I have been doing to get to the final sketch (Halos In Kaos) that we have been asked to deliver. It is curious that, as the first task, we were asked to make a Gaudi star because my Master's Final Project will be based on the Catalan modernism (what a cool coincidence). In the experimental sketches I have been playing with irregular polygons (as is done in trencadís) and with deformed curves based on natural formations. Also, I've been painting with my live music connecting Ableton and Processing via OSC. 

**Final sketch: Halos In Kaos**

Halos In Kaos is a generative art project created using Processing. The project generates a series of dynamic polygonal shapes that rotate and pulse around a constantly moving center. These polygons are surrounded by arcs of various styles, which rotate and shift, creating a visually chaotic yet harmonious effect.

**Features**

- Dynamic Polygons: Multiple polygons are generated with a random number of vertices. The polygons rotate and change shape and color as time progresses.
- Pulse Effect: The polygons grow and shrink in size with a pulsing effect, synchronized with a defined frequency and amplitude.
- Moving Arcs: Around each polygon, arcs are drawn that rotate and transform, adding visual complexity to the scene.
- Dynamic Regeneration: The scene regenerates at specific time intervals, changing the origin position of the polygons, which makes the animation feel continually fresh and alive.
- Lighting Usage: The project uses directional and ambient lighting to add depth and realism to the 3D shapes.

**Code Structure**

The code is mainly structured into two parts:

1. Initialization (setup):
   - Sets up the canvas size, frame rate, and the initial parameters of the polygons and arcs.
   - The origin point is established at the center of the canvas, and the polygons and arcs are generated.
2. Drawing (draw):
   - The scene is updated on each frame, including the rotation and pulsing of the polygons.
   - At each time interval, the scene regenerates by moving the origin of the polygons and resetting their colors and vertices.
   - The polygons and the surrounding arcs are drawn, applying the configured lights to create a 3D effect.

**How It Works**

When the program starts, the polygons are configured with a random number of vertices, and they are assigned colors and positions in 3D space. During each drawing cycle, the polygons rotate and pulse, while the arcs around them also animate independently. At specific time intervals, the origin point of the polygons randomly changes within the canvas, creating a new visual configuration.

**Usage**

To run HalosInKaos, you’ll need to have Processing installed. Simply download the code and open it in Processing, then run the sketch to see the animation in real time.

**Customization**

You can adjust the following parameters to change the behavior of the animation:

- numPolygons: Number of polygons generated.
- pulseAmplitude and pulseFrequency: Control the intensity and speed of the pulsing effect.
- regenerationInterval: Time interval in milliseconds before the scene regenerates.


