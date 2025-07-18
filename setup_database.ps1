# Festival Archive Database Setup Script for Windows
# This script creates the database and runs all migrations using PowerShell

param(
    [string]$DBName = "festival_archive",
    [string]$DBUser = "festival_user",
    [string]$DBPassword = "your_secure_password_here",
    [string]$DBHost = "localhost",
    [string]$DBPort = "5432"
)

# Function to write colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to check if PostgreSQL is accessible
function Test-PostgreSQLConnection {
    Write-ColorOutput "Checking PostgreSQL connection..." "Yellow"
    
    try {
        $result = & pg_isready -h $DBHost -p $DBPort 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✅ PostgreSQL is running" "Green"
            return $true
        } else {
            Write-ColorOutput "❌ PostgreSQL is not running or not accessible" "Red"
            Write-ColorOutput "Please start PostgreSQL and try again" "Red"
            return $false
        }
    } catch {
        Write-ColorOutput "❌ PostgreSQL client not found" "Red"
        Write-ColorOutput "Please install PostgreSQL client tools" "Red"
        return $false
    }
}

# Function to create database and user
function New-FestivalDatabase {
    Write-ColorOutput "Creating database and user..." "Yellow"
    
    try {
        # Create user (if not exists)
        $createUserQuery = "CREATE USER $DBUser WITH PASSWORD '$DBPassword';"
        & psql -h $DBHost -p $DBPort -U postgres -c $createUserQuery 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✅ User created successfully" "Green"
        } else {
            Write-ColorOutput "ℹ️ User already exists" "Cyan"
        }
        
        # Create database (if not exists)
        $createDBQuery = "CREATE DATABASE $DBName OWNER $DBUser;"
        & psql -h $DBHost -p $DBPort -U postgres -c $createDBQuery 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✅ Database created successfully" "Green"
        } else {
            Write-ColorOutput "ℹ️ Database already exists" "Cyan"
        }
        
        # Grant privileges
        $grantQuery = "GRANT ALL PRIVILEGES ON DATABASE $DBName TO $DBUser;"
        & psql -h $DBHost -p $DBPort -U postgres -c $grantQuery
        Write-ColorOutput "✅ Privileges granted" "Green"
        
    } catch {
        Write-ColorOutput "❌ Error creating database: $($_.Exception.Message)" "Red"
        return $false
    }
    
    return $true
}

# Function to run migrations
function Invoke-Migrations {
    Write-ColorOutput "Running migrations..." "Yellow"
    
    # Set environment variable for password
    $env:PGPASSWORD = $DBPassword
    
    # Get all migration files in order
    $migrationFiles = Get-ChildItem -Path "migrations" -Filter "*.sql" | Sort-Object Name
    
    foreach ($migration in $migrationFiles) {
        Write-ColorOutput "Running: $($migration.Name)" "Cyan"
        
        try {
            & psql -h $DBHost -p $DBPort -U $DBUser -d $DBName -f $migration.FullName
            if ($LASTEXITCODE -eq 0) {
                Write-ColorOutput "✅ $($migration.Name) completed" "Green"
            } else {
                Write-ColorOutput "❌ Error in $($migration.Name)" "Red"
                return $false
            }
        } catch {
            Write-ColorOutput "❌ Error running $($migration.Name): $($_.Exception.Message)" "Red"
            return $false
        }
    }
    
    Write-ColorOutput "✅ All migrations completed" "Green"
    return $true
}

# Function to verify setup
function Test-DatabaseSetup {
    Write-ColorOutput "Verifying database setup..." "Yellow"
    
    try {
        $env:PGPASSWORD = $DBPassword
        $tableCountQuery = "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';"
        $result = & psql -h $DBHost -p $DBPort -U $DBUser -d $DBName -t -c $tableCountQuery
        
        if ($LASTEXITCODE -eq 0) {
            $count = $result.Trim()
            if ([int]$count -ge 9) {
                Write-ColorOutput "✅ Database setup verified ($count tables created)" "Green"
                return $true
            } else {
                Write-ColorOutput "❌ Database setup verification failed (only $count tables found)" "Red"
                return $false
            }
        } else {
            Write-ColorOutput "❌ Could not verify database setup" "Red"
            return $false
        }
    } catch {
        Write-ColorOutput "❌ Error verifying setup: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Function to show connection information
function Show-ConnectionInfo {
    Write-ColorOutput "🎉 Database setup completed successfully!" "Green"
    Write-Host ""
    Write-ColorOutput "Connection Information:" "White"
    Write-ColorOutput "======================" "White"
    Write-ColorOutput "Database: $DBName" "White"
    Write-ColorOutput "User: $DBUser" "White"
    Write-ColorOutput "Host: $DBHost" "White"
    Write-ColorOutput "Port: $DBPort" "White"
    Write-Host ""
    Write-ColorOutput "To connect using psql:" "White"
    Write-ColorOutput "psql -h $DBHost -p $DBPort -U $DBUser -d $DBName" "Cyan"
    Write-Host ""
    Write-ColorOutput "Or set the PGPASSWORD environment variable:" "White"
    Write-ColorOutput "`$env:PGPASSWORD = '$DBPassword'" "Cyan"
    Write-Host ""
    Write-ColorOutput "Sample queries:" "White"
    Write-ColorOutput "===============" "White"
    Write-ColorOutput "SELECT * FROM artists;" "Cyan"
    Write-ColorOutput "SELECT * FROM works_with_artists;" "Cyan"
    Write-ColorOutput "SELECT * FROM edition_stats;" "Cyan"
}

# Main execution
function Main {
    Write-ColorOutput "🎭 Festival Archive Database Setup" "Green"
    Write-ColorOutput "==================================" "Green"
    Write-Host ""
    
    # Check PostgreSQL connection
    if (-not (Test-PostgreSQLConnection)) {
        exit 1
    }
    
    # Create database
    if (-not (New-FestivalDatabase)) {
        exit 1
    }
    
    # Run migrations
    if (-not (Invoke-Migrations)) {
        exit 1
    }
    
    # Verify setup
    if (-not (Test-DatabaseSetup)) {
        exit 1
    }
    
    # Show connection info
    Show-ConnectionInfo
}

# Run main function
Main 