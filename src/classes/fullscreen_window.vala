/**
 * Fullscreen Window
 *
 * This file is part of pdf-presenter-console.
 *
 * pdf-presenter-console is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3 of the License.
 *
 * pdf-presenter-console is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * pdf-presenter-console; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

using Gtk;
using Gdk;

namespace org.westhoffswelt.pdfpresenter {

    /**
     * Window extension implementing all the needed functionality, to be
     * displayed fullscreen.
     *
     * Methods to specify the monitor to be displayed on in a multi-head setup
     * are provided as well.
     */
    public class FullscreenWindow: Gtk.Window {
        /**
         * The geometry data of the screen this window is on
         */
        protected Rectangle screen_geometry;

        public FullscreenWindow( int screen_num ) {
            var screen = Screen.get_default();
            screen.get_monitor_geometry( screen_num, out this.screen_geometry );

            // Move to the correct monitor
            // This movement is done here and after mapping, to minimize flickering
            // with window managers, which correctly handle the movement command,
            // before the window is mapped.
            this.move( this.screen_geometry.x, this.screen_geometry.y );
            this.fullscreen();

            // As certain window-managers like Xfwm4 ignore movement request
            // before the window is initially moved and set up we need to
            // listen to this event.
            this.size_allocate.connect( this.on_size_allocate );
        }

        /**
         * Called if window size is allocated
         *
         * This method is needed, because certain window manager (eg. Xfwm4) ignore
         * movement commands before the window has been displayed for the first
         * time.
         */
        protected void on_size_allocate( Rectangle r ) {
            if ( this.is_mapped() ) {
                // We are only interested to handle this event AFTER the window has
                // been mapped.

                // Remove the signal handler, as we only want to handle this once
                this.size_allocate.disconnect( this.on_size_allocate );

                // We only need to do all this, if the window is not at the
                // correct position. Otherwise it would only cause flickering
                // without any effect.
                int x,y;
                this.get_position( out x, out y );
                if ( x == this.screen_geometry.x && y == this.screen_geometry.y ) {
                    return;
                }

                // Certain window manager (eg. Xfce4) do not allow window movement
                // while the window is maximized. Therefore it is ensured the
                // window is not in this state.
                this.unfullscreen();
                this.unmaximize();

                // The first movement might not have worked as expected, because of
                // the before mentioned maximized window problem. Therefore it is
                // done again
                this.move( this.screen_geometry.x, this.screen_geometry.y );

                this.fullscreen();
            }
        }
    }
}