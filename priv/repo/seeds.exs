# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
alias Forumid.Repo
alias Forumid.Accounts
alias Forumid.Authorization
alias Forumid.AccessControl

# 1. Seed Roles
system_roles = Application.get_env(:forumid, :system_roles, [])

admin_role =
  Enum.find_value(system_roles, fn role_name ->
    {:ok, role} =
      case Repo.get_by(Authorization.Role, name: role_name) do
        nil ->
          Authorization.create_role(%{name: role_name, description: "System #{role_name} role"})

        role ->
          {:ok, role}
      end

    # Kita gunakan role "admin" sebagai role utama untuk seeding permission
    if role_name == "admin", do: role, else: nil
  end)

# Fallback jika "admin" tidak ada di list, ambil role pertama
admin_role = admin_role || hd(system_roles)

# 2. Seed Permissions & Assign to Admin Role
system_permissions = Application.get_env(:forumid, :system_permissions, [])

for {resource, action} <- system_permissions do
  {:ok, permission} =
    case Repo.get_by(Authorization.Permission, resource: resource, action: action) do
      nil ->
        Authorization.create_permission(%{
          resource: resource,
          action: action,
          description: "Can #{action} #{resource}"
        })

      perm ->
        {:ok, perm}
    end

  # Berikan permission ini ke admin_role
  case AccessControl.assign_permission(admin_role.id, permission.id) do
    {:ok, _} -> IO.puts("Assigned #{resource}:#{action} to #{admin_role.name}")
    {:error, :permission_already_assigned} -> :ok
  end
end

# 3. Create Default Admin User
admin_email = "admin@forumid.dev"

case Accounts.get_user_by_email(admin_email) do
  nil ->
    # Hash password secara manual menggunakan Bcrypt
    hashed_password = Bcrypt.hash_pwd_salt("supersecretadmin123")

    # Insert user langsung ke database dengan status sudah terkonfirmasi
    {:ok, admin_user} =
      %Accounts.User{}
      |> Ecto.Changeset.change(%{
        email: admin_email,
        hashed_password: hashed_password,
        confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)
      })
      |> Repo.insert()

    # Berikan role admin ke user ini
    {:ok, _} = AccessControl.assign_role(admin_user.id, admin_role.id)

    IO.puts("\n========================================")
    IO.puts("Admin user created successfully!")
    IO.puts("Email: #{admin_email}")
    IO.puts("Password: supersecretadmin123")
    IO.puts("========================================\n")

  _user ->
    IO.puts("Admin user (#{admin_email}) already exists.")
end
