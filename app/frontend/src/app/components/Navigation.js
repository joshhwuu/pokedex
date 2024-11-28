import Link from 'next/link';

export default function Nav() {
  return (
    <nav className="flex flex-col space-y-2 p-4 bg-gray-200 h-full">
      <Link
        href="/"
        className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        Home
      </Link>
      <Link
        href="/gym-leaders"
        className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        Gym Leaders
      </Link>
      <Link
        href="/move-stats"
        className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        Move Stats
      </Link>
      <Link
        href="/trainer-query"
        className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        Trainer Query
      </Link>
    </nav>
  );
}
