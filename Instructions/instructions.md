

EatFit is native iOS app, in which user can click the food pic and see its fitness related info


🍽️ Food Analyzer App Flow
Modules
1. Splash Screen
    * Display the App Name centered on the screen.
    * Optional: Add a simple animation or fade-in effect.
    * Automatically navigate to the Home screen after a short delay (e.g., 2 seconds).
2. Home Screen
    * Show a "Click Food" button prominently.
3. Open Camera
    * On tapping the Click Food button, launch the device's camera interface.
    * Allow the user to capture a food photo.
4. Photo Preview & Analyze Option
    * After capturing, display the photo in a small preview view.
    * Below the preview, show an "Analyze Food" button.
5. Food Analysis
    * On clicking Analyze Food, send the captured photo to the OpenAI API.
    * Extract the following nutritional information:
        * 🧂 Ingredients
        * 🔥 Calories
        * 🍚 Carbohydrates
        * 🥩 Protein
        * 🧈 Fat
6. Display & Store Data
    * Present the analysis in a Card View layout.
        * Include the captured image and extracted data.
    * Save this data locally using Realm Database for offline persistence.
7. History of Analyzed Foods
    * On the Home Screen, below the Click Food button, display a scrollable list of saved food analysis cards.
    * Each card shows the photo and the related nutritional data.
	