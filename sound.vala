
public class SoundPlayer: GLib.Object
{
    public string event_id { get; private construct set; }
    public double volume { get; set; default = 1.0; }

    private GLib.File file;
    private Canberra.Context context;
    private bool is_cached = false;

    public SoundPlayer (string? event_id, GLib.File file) 
    {
        Canberra.Context context;

        var status = Canberra.Context.create (out context);
        var application = GLib.Application.get_default ();

        if (status != Canberra.SUCCESS) {
            print("Failed to initialize canberra context - %s".printf (Canberra.strerror (status)));
        }

        status = context.change_props (
            Canberra.PROP_APPLICATION_ID, application.application_id);

        if (status != Canberra.SUCCESS) {
            print("Failed to set context properties - %s".printf (Canberra.strerror (status)));
        }

        status = context.open ();

        if (status != Canberra.SUCCESS) {
            print("Failed to open canberra context - %s".printf (Canberra.strerror (status)));
        }

        this.context = (owned) context;
        this.event_id = event_id;
        this.file = file;
        cache_file();
    }

    ~SoundPlayer ()
    {
    }

    private static double amplitude_to_decibels (double amplitude)
    {
        return 20.0 * Math.log10 (amplitude);
    }

    public void play ()
    {
        if (context != null)
        {
            Canberra.Proplist properties = null;

            var status = Canberra.Proplist.create (out properties);
            properties.sets (Canberra.PROP_MEDIA_ROLE, "alert");
            properties.sets (Canberra.PROP_MEDIA_FILENAME, file.get_path ());
            properties.sets (Canberra.PROP_CANBERRA_VOLUME,
                             ((float) amplitude_to_decibels (volume)).to_string ());

            if (event_id != null) {
                properties.sets (Canberra.PROP_EVENT_ID, event_id);

                if (!is_cached) {
                    cache_file ();
                }
            }

            status = context.play_full(0, properties, on_play_callback);

            if (status != Canberra.SUCCESS) {
                GLib.warning ("Couldn't play sound '%s' - %s", file.get_uri (),
                              Canberra.strerror (status));
            }

            print("status: %i\n", status);
        }
        else {
            GLib.warning ("Couldn't play sound '%s'", file.get_uri ());
        }
    }

    private void cache_file ()
    {
        Canberra.Proplist properties = null;

        if (context != null && event_id != null && file != null)
        {
            var status = Canberra.Proplist.create (out properties);
            properties.sets (Canberra.PROP_EVENT_ID, event_id);
            properties.sets (Canberra.PROP_MEDIA_FILENAME, file.get_path ());

            status = context.cache_full (properties);

            if (status != Canberra.SUCCESS) {
                GLib.warning ("Couldn't clear libcanberra cache - %s",
                              Canberra.strerror (status));
            }
            else {
                is_cached = true;
            }
        }
    }

    private void on_play_callback (Canberra.Context context,
                                   uint32           id,
                                   int              code)
    {
    }
}

