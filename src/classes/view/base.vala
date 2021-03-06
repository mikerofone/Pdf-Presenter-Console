/**
 * Slide View
 *
 * This file is part of pdf-presenter-console.
 *
 * Copyright (C) 2010-2011 Jakob Westhoff <jakob@westhoffswelt.de>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

using GLib;

namespace org.westhoffswelt.pdfpresenter {
    /**
     * Base class for every slide view
     */
    public abstract class View.Base: Gtk.DrawingArea {
        /**
         * Signal fired every time a slide is about to be left
         */
        public signal void leaving_slide( int from, int to );

        /**
         * Signal fired every time a slide is entered
         */
        public signal void entering_slide( int slide_number );
        
        /**
         * Renderer to be used for rendering the slides
         */
        protected Renderer.Base renderer;

        /**
         * Base constructor taking the renderer to use as an argument
         */
        protected Base( Renderer.Base renderer ) {
            this.renderer = renderer;
            this.set_size_request( 
                renderer.get_width(),
                renderer.get_height()
            );
        }
        
        /**
         * Return the used renderer object
         */
        public Renderer.Base get_renderer() {
            return this.renderer;
        }

        /**
         * Goto the next slide
         *
         * If the end of slides is reached this method is expected to do
         * nothing.
         */
        public abstract void next();

        /**
         * Go forward 10 slides
         *
         * If the end of slides is reached this method is expected to do
         * nothing.
         */
        public abstract void jumpN( int n );

        /**
         * Goto the previous slide
         *
         * If the beginning of slides is reached this method is expected to do
         * nothing.
         */
        public abstract void previous();

        /**
         * Go back 10 slides
         *
         * If the beginning of slides is reached this method does nothing.
         */
        public abstract void backN( int n );

        /**
         * Goto a specific slide number
         *
         * If the slide number does not exist a RenderError.SLIDE_DOES_NOT_EXIST is thrown
         */
        public abstract void display( int slide_number, bool force_redraw=false )
            throws Renderer.RenderError;

        /**
         * Make the screen black. Useful for presentations together with a whiteboard
         */
        public abstract void fade_to_black();

        /**
         * Redraw the current slide. Useful for example when exiting from fade_to_black
         */
        public abstract void redraw() throws Renderer.RenderError;

        /**
         * Return the currently shown slide number
         */
        public abstract int get_current_slide_number();
    }
}
