namespace GameState {
    bool gameOver = false;
};

class GameController : Behaviour {
    private int score = 0;

    Actor @panel = null;
    Button @startBtn = null;

    RigidBody @bird = null;

    private Scene @level = null;

    private Vector3 impulse(0.0f, 5.0f, 0.0f);
    private Vector3 point(0.0f, 0.0f, 0.0f);

    void start() override {
        bool result = connect(startBtn, _SIGNAL("clicked()"), this, _SLOT("onStartClicked()"));

        GameState::gameOver = false;
    }

    void update() override {
        if(!GameState::gameOver && Input::isMouseButtonDown(Input::KeyCode::MOUSE_LEFT) && (bird !is null)) {
            bird.applyImpulse(impulse, point);
        }
    }

    private void onStartClicked() {
        if(panel !is null) {
            panel.enabled = false;
        }

        @level = Engine::loadScene("Level.map", true);
        // Find bird
        if(level !is null) {
            Actor @birdActor = cast<Actor>(level.find("Bird"));
            if(birdActor !is null) {
                @bird = cast<RigidBody>(birdActor.component("RigidBody"));
                if(bird !is null) {
                    connect(bird, _SIGNAL("entered()"), this, _SLOT("onBirdCollide()"));
                    GameState::gameOver = false;
                }
            }
        }
    }

    private void onBirdCollide() { // slot definition
        GameState::gameOver = true;
        @bird = null;
        // Show Game Over UI
        if(panel !is null) {
            panel.enabled = true;
        }
        Engine::unloadScene(level);
    }
};
