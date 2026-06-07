import { createRoot } from "react-dom/client";
import "./index.css";
import App from "./App.jsx";
import AdminPage from "./pages/AdminPage.jsx";

const isAdmin = window.location.pathname.startsWith("/admin");

if (isAdmin) {
  document.title = "DevReady Admin";
}

createRoot(document.getElementById("root")).render(isAdmin ? <AdminPage /> : <App />);
