/**
 * A demo of how to play a wav file in a Gtk application using libcanberra
 */

public class SoundPlayerApp: Gtk.Application {
    public SoundPlayerApp() {
        Object(application_id: "testing.sound.player",
               flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {
        Gtk.ApplicationWindow window = new Gtk.ApplicationWindow (this);
        window.set_default_size (300, 200);
        window.title = "Sound Player";

        sound_player = new SoundPlayer("beep", File.new_for_path("beep.wav"));

        Gtk.Button btn = new Gtk.Button();
        btn.set_label("Play");
        btn.clicked.connect(() => {
            sound_player.play();
        });

        window.add (btn);
        window.show_all ();
    }

    public static int main (string[] args) {
        SoundPlayerApp app = new SoundPlayerApp();
        return app.run (args);
    }

    private SoundPlayer sound_player;
}
