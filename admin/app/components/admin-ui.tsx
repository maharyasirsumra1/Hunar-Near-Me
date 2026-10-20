import {
  ClipboardList,
  Grid2X2,
  HardHat,
  LayoutDashboard,
  MapPin,
  Megaphone,
  ScrollText,
  SlidersHorizontal,
  Star,
  UsersRound,
  Wallet,
} from 'lucide-react';

export type AdminTab =
  | 'overview'
  | 'workers'
  | 'customers'
  | 'payments'
  | 'services'
  | 'locations'
  | 'reviews'
  | 'bookings'
  | 'content'
  | 'notifications'
  | 'audit';

export const tabs = [
  ['overview', 'Overview', LayoutDashboard],
  ['workers', 'Worker Approvals', HardHat],
  ['customers', 'Customers', UsersRound],
  ['payments', 'Fee Verification', Wallet],
  ['services', 'Services', Grid2X2],
  ['locations', 'Pakistan Locations', MapPin],
  ['reviews', 'Reviews', Star],
  ['bookings', 'Bookings', ClipboardList],
  ['content', 'App Labels & Images', SlidersHorizontal],
  ['notifications', 'Announcements', Megaphone],
  ['audit', 'Audit Log', ScrollText],
] as const;

export const titles: Record<AdminTab, string> = {
  overview: 'Dashboard',
  workers: 'Worker Applications',
  customers: 'Customer Management',
  notifications: 'Announcements',
  payments: 'Fee Verification',
  services: 'Service Types',
  locations: 'Location Management',
  reviews: 'Customer Reviews',
  bookings: 'Bookings & Requests',
  content: 'App Content & Branding',
  audit: 'Admin Activity',
};

export function date(value: string) {
  return value
    ? new Date(value).toLocaleDateString('en-PK', {
        month: 'short',
        day: 'numeric',
        year: 'numeric',
      })
    : '—';
}

export function status(value: string) {
  return <span className={`status ${value}`}>{value}</span>;
}

interface FieldProps {
  label: string;
  value: unknown;
  onChange: (value: string) => void;
  placeholder?: string;
  type?: string;
}

export function Field({
  label,
  value,
  onChange,
  placeholder,
  type = 'text',
}: FieldProps) {
  return (
    <label className="field">
      {label}
      <input
        type={type}
        placeholder={placeholder}
        value={value == null ? '' : String(value)}
        onChange={(event) => onChange(event.target.value)}
      />
    </label>
  );
}
