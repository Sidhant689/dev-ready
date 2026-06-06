import { useState, useEffect } from "react";
import { supabase } from "../config/supabaseClient";

export function useAdminAuth() {
  const [status, setStatus] = useState("loading"); // "loading" | "admin" | "denied"
  const [adminUser, setAdminUser] = useState(null);

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data: { user } }) => {
      if (!user) { setStatus("denied"); return; }

      const { data, error } = await supabase
        .from("users")
        .select("id, email, full_name, role")
        .eq("id", user.id)
        .single();

      if (error || data?.role !== "admin") {
        setStatus("denied");
      } else {
        setAdminUser(data);
        setStatus("admin");
      }
    });
  }, []);

  return { status, adminUser };
}
