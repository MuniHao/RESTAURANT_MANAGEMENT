using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

class Database
{
    public static SqlConnection Connection;

    public static bool Connect()
    {
        try
        {
            Connection = new SqlConnection("Server=baedontcry;Database=RESTAURANT_MANAGEMENT;Integrated Security=True;");
            Connection.Open();
            Console.WriteLine("Successfully connected to database server");
            return true;
        }
        catch (Exception ex)
        {
            MessageBox.Show("Failed to connect to database server:\n" + ex.Message);
            Console.WriteLine("ERROR DATABASE: " + ex.ToString());
            return false;
        }
    }

    public static bool Close()
    {
        try
        {
            if (Connection != null && Connection.State != ConnectionState.Closed)
            {
                Connection.Close();
            }
            return true;
        }
        catch (Exception ex)
        {
            Console.WriteLine("ERROR CLOSING DATABASE: " + ex.ToString());
            return false;
        }
    }

    public static DataTable ExecuteQuery(string cmd, object[] paras = null)
    {
        DataTable data = new DataTable();
        try
        {
            if (Connection == null || Connection.State != ConnectionState.Open)
            {
                if (!Connect())
                {
                    throw new Exception("Cannot connect to database.");
                }
            }

            using (SqlCommand command = new SqlCommand(cmd, Connection))
            {
                if (paras != null)
                {
                    string[] listPara = cmd.Split(' ');
                    int i = 0;
                    foreach (string s in listPara)
                    {
                        if (s.Contains("@"))
                        {
                            command.Parameters.AddWithValue(s, paras[i]);
                            i++;
                        }
                    }
                }
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    adapter.Fill(data);
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.ToString()}");
            throw;
        }
        finally
        {
            Close();
        }
        return data;
    }

    public static int ExecuteNonQuery(string cmd, object[] paras = null)
    {
        int data = 0;
        try
        {
            if (Connection == null || Connection.State != ConnectionState.Open)
            {
                if (!Connect())
                {
                    throw new Exception("Cannot connect to database.");
                }
            }

            using (SqlCommand command = new SqlCommand(cmd, Connection))
            {
                if (paras != null)
                {
                    string[] listPara = cmd.Split(' ');
                    int i = 0;
                    foreach (string s in listPara)
                    {
                        if (s.Contains("@"))
                        {
                            command.Parameters.AddWithValue(s, paras[i]);
                            i++;
                        }
                    }
                }
                data = command.ExecuteNonQuery();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.ToString()}");
            throw;
        }
        finally
        {
            Close();
        }
        return data;
    }

    public static object ExecuteScalar(string cmd, object[] paras = null)
    {
        object data = null;
        try
        {
            if (Connection == null || Connection.State != ConnectionState.Open)
            {
                if (!Connect())
                {
                    throw new Exception("Cannot connect to database.");
                }
            }

            using (SqlCommand command = new SqlCommand(cmd, Connection))
            {
                if (paras != null)
                {
                    string[] listPara = cmd.Split(' ');
                    int i = 0;
                    foreach (string s in listPara)
                    {
                        if (s.Contains("@"))
                        {
                            command.Parameters.AddWithValue(s, paras[i]);
                            i++;
                        }
                    }
                }
                data = command.ExecuteScalar();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.ToString()}");
            throw;
        }
        finally
        {
            Close();
        }
        return data;
    }
}