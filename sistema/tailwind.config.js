/** @type {import('tailwindcss').Config} */
module.exports = {
  // Aquí le decimos a Tailwind que lea todos los archivos .html dentro de templates/
  content: [
    "./templates/**/*.html",
    "./static/js/**/*.js",
    "./main.py"
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}