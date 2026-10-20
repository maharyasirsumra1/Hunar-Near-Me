import type { FormEvent } from 'react';
import { Field } from './admin-ui';

interface AdminLoginProps {
  phone: string;
  password: string;
  busy: boolean;
  error: string;
  onPhoneChange: (value: string) => void;
  onPasswordChange: (value: string) => void;
  onSubmit: (event: FormEvent<HTMLFormElement>) => void;
}

export function AdminLogin({
  phone,
  password,
  busy,
  error,
  onPhoneChange,
  onPasswordChange,
  onSubmit,
}: AdminLoginProps) {
  return (
    <div className="login">
      <form onSubmit={onSubmit} className="loginbox">
        <h1>Hunar Near Me</h1>
        <p>Secure Administrator Login</p>
        <Field
          label="Admin mobile number"
          value={phone}
          onChange={onPhoneChange}
          placeholder="03001234567"
        />
        <Field
          label="Password"
          type="password"
          value={password}
          onChange={onPasswordChange}
        />
        <button disabled={busy} className="btn" style={{ width: '100%' }}>
          {busy ? 'Signing in…' : 'Sign in to Admin Panel'}
        </button>
        {error && <div className="error">{error}</div>}
        <p className="hint" style={{ marginTop: 18 }}>
          Your initial admin credentials are defined in backend/.env. Never
          share them or use a demo password on a public server.
        </p>
      </form>
    </div>
  );
}
