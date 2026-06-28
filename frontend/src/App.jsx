import { Routes, Route, Navigate } from "react-router";
import { ThemeProvider } from "./context/ThemeContext";
import { WallpaperProvider } from "./context/WallpaperContext";
import ChatPage from "./pages/ChatPage";
import AuthPage from "./pages/AuthPage";
import { useAuth } from "@clerk/react";
import PageLoader from "./components/PageLoader";

function App() {
  const { isSignedIn, isLoaded } = useAuth();

  if(!isLoaded) return <PageLoader />

  return (
    <ThemeProvider>
      <WallpaperProvider>
        <Routes>
          <Route
            path="/"
            element={
              isSignedIn ? <ChatPage /> : <Navigate to={"/auth"} replace />
            }
          />
          <Route
            path="/auth"
            element={
              !isSignedIn ? <AuthPage /> : <Navigate to={"/"} replace />
            }
          />
        </Routes>
        {/* <h1 className="text-7xl text-red-600">My app</h1>
        <Button>My click</Button>
        <header>
          <Show when="signed-out">
            <SignInButton mode="modal" />
            <SignUpButton mode="modal" />
          </Show>
          <Show when="signed-in">
            <UserButton />
          </Show>
        </header> */}
      </WallpaperProvider>
    </ThemeProvider>
  );
}

export default App;
