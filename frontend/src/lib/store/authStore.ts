import { create } from "zustand";
import { persist } from "zustand/middleware";

interface AuthState {
  accessToken: string | null;
  refreshToken: string | null;
  memberType: "INDIVIDUAL" | "CORPORATE" | "ADMIN" | null;
  setTokens: (accessToken: string, refreshToken: string) => void;
  setMemberType: (type: AuthState["memberType"]) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      accessToken: null,
      refreshToken: null,
      memberType: null,
      setTokens: (accessToken, refreshToken) => set({ accessToken, refreshToken }),
      setMemberType: (memberType) => set({ memberType }),
      logout: () => set({ accessToken: null, refreshToken: null, memberType: null }),
    }),
    { name: "auth-storage" }
  )
);
