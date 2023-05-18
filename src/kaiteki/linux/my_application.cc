#include "my_application.h"

#include <flutter_linux/flutter_linux.h>

#include <handy.h>

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication
{
  GtkApplication parent_instance;
  char **dart_entrypoint_arguments;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

// Implements GApplication::activate.
static void my_application_activate(GApplication *application)
{
  MyApplication *self = MY_APPLICATION(application);
  GtkWindow *window = GTK_WINDOW(hdy_application_window_new());
  gtk_window_set_application(window, GTK_APPLICATION(application));

  GtkBox *box = GTK_BOX(gtk_box_new(GTK_ORIENTATION_VERTICAL, 0));
  gtk_widget_show(GTK_WIDGET(box));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(box));

  HdyHeaderBar *header_bar = HDY_HEADER_BAR(hdy_header_bar_new());
  gtk_widget_show(GTK_WIDGET(header_bar));
  hdy_header_bar_set_title(header_bar, "Kaiteki");
  hdy_header_bar_set_show_close_button(header_bar, TRUE);
  gtk_box_pack_start(GTK_BOX(box), GTK_WIDGET(header_bar), false, true, 0);

  gtk_window_set_default_size(window, 1280, 720);
  gtk_widget_show(GTK_WIDGET(window));

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView *view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_box_pack_end(GTK_BOX(box), GTK_WIDGET(view), true, true, 0);

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

static void my_application_class_init(MyApplicationClass *klass)
{
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
}

static void my_application_init(MyApplication *self) {}

MyApplication *my_application_new()
{
  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID,
                                     nullptr));
}
