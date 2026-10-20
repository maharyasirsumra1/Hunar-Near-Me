import { LogOut } from 'lucide-react';
import { tabs } from './admin-ui';
import type { AdminTab } from './admin-ui';

interface AdminSidebarProps {
  activeTab: AdminTab;
  onSelect: (tab: AdminTab) => void;
  onLogout: () => void;
}

export function AdminSidebar({
  activeTab,
  onSelect,
  onLogout,
}: AdminSidebarProps) {
  return (
    <aside className="sidebar">
      <div className="brand">
        🔧 Hunar Near Me
        <small>Business Control Center</small>
      </div>
      {tabs.map(([id, label, Icon]) => (
        <button
          key={id}
          className={`nav ${activeTab === id ? 'active' : ''}`}
          onClick={() => onSelect(id)}
        >
          <Icon size={18} />
          {label}
        </button>
      ))}
      <div className="spacer" />
      <button className="nav" onClick={onLogout}>
        <LogOut size={18} />
        Logout
      </button>
    </aside>
  );
}
