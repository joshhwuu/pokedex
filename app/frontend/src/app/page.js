"use client";

export default function Home() {
  const handleReload = async () => {
    try {
      const response = await fetch("http://localhost:8008/reload", {
        method: "POST",
      });
      if (!response.ok) {
        throw new Error("Network response was not ok");
      }
      alert("Tables reloaded successfully");
    } catch (error) {
      console.error("Error reloading tables:", error);
      alert("Error reloading tables");
    }
  };

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold text-gray-700">Home Page</h1>
      <button
        onClick={handleReload}
        className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mt-4"
      >
        Reload Tables
      </button>
    </div>
  );
}
