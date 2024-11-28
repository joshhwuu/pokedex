import localFont from 'next/font/local';
import Nav from './components/Navigation';
import './globals.css';

const geistSans = localFont({
  src: './fonts/GeistVF.woff',
  variable: '--font-geist-sans',
  weight: '100 900',
});
const geistMono = localFont({
  src: './fonts/GeistMonoVF.woff',
  variable: '--font-geist-mono',
  weight: '100 900',
});

export const metadata = {
  title: 'Not Pokedex',
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased`}
      >
        <div className="flex h-screen">
          <div className="w-1/4">
            <Nav />
          </div>
          <div className="w-3/4 p-4 bg-white">{children}</div>
        </div>
      </body>
    </html>
  );
}
