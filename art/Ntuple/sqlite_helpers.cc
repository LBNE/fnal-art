// =======================================================
//
// sqlite helpers
//
// =======================================================

#include <cassert>
#include <cmath>

#include "art/Ntuple/sqlite_helpers.h"

namespace sqlite
{

  namespace detail
  {

    //=======================================================================
    int getResult(void* data, int ncols [[gnu::unused]], char** results, char** /*cnames*/)
    {
      assert(ncols >= 1);
      query_result* j = static_cast<query_result*>(data);
      sqlite::stringstream resultStream;
      for ( int i(0); i < ncols ; ++i ) {
        resultStream << results[i];
      }
      j->data.emplace_back( std::move(resultStream) );
      return 0;
    }

    //=======================================================================
    query_result query(sqlite3* db,std::string const& ddl)
    {
      query_result res;
      char* errmsg = nullptr;
      if ( sqlite3_exec(db, ddl.c_str(), detail::getResult, &res, &errmsg) != SQLITE_OK )
        {
          std::string msg(errmsg);
          sqlite3_free(errmsg);
          throw art::Exception(art::errors::SQLExecutionError, msg);
        }
      return res;
    }

    //=========================================================================
    /// hasTable(db, name, cnames) returns true if the db has a
    /// table named 'name', with colums named 'cns' suitable for carrying a
    /// tuple<ARGS...>. It returns false if there is no table of that name, and
    /// throws an exception if there is a table of the given name but it
    /// does not match both the given column names and column types.
    bool hasTable(sqlite3* db, std::string const& name, std::string const& sqlddl)
    {
      std::string cmd("select sql from sqlite_master where type=\"table\" and name=\"");
      cmd += name;
      cmd += '"';

      detail::query_result const res = query(db, cmd);

      if (res.data.size() == 0) { return false; }
      if (res.data.size() == 1 && res.data[0][0] == sqlddl) { return true; }
      throw art::Exception(art::errors::SQLExecutionError,
                           "Existing database table name does not match description");
    }

  } // namespace detail

  //=======================================================================
  sqlite3* openDatabaseFile(std::string const& filename)
  {
    sqlite3* db = nullptr;
    int const rc = sqlite3_open_v2(filename.c_str(),
                                   &db,
                                   SQLITE_OPEN_READWRITE|SQLITE_OPEN_CREATE,
                                   nullptr);
    if (rc != SQLITE_OK) {
      throw art::Exception(art::errors::SQLExecutionError,"Failed to open SQLite database");
    }

    return db;
  }

  //=======================================================================
  void exec(sqlite3* db,std::string const& ddl)
  {
    char* errmsg = nullptr;
    if ( sqlite3_exec(db, ddl.c_str(), nullptr, nullptr, &errmsg) != SQLITE_OK )
      {
        std::string msg(errmsg);
        sqlite3_free(errmsg);
        throw art::Exception(art::errors::SQLExecutionError, msg);
      }
  }

  //=======================================================================
  void deleteTable( sqlite3* db, std::string const& tname )
  {
    exec( db, std::string("delete from ") + tname );
  }

  void dropTable( sqlite3* db, std::string const& tname )
  {
    exec( db, std::string("drop table ") + tname );
  }

  //=======================================================================
  // Statistics helpers

  double mean( sqlite3* db, const std::string& tname, const std::string& colname ){
    return query_db<double>( db, std::string("select avg(")+colname+std::string(") from ") + tname );
  }

  double median( sqlite3* db, const std::string& tname, const std::string& colname ){
    return query_db<double>( db,
                             std::string("select avg(")+colname+std::string(")")+
                             std::string(" from (select ")+colname+
                             std::string(" from ")+tname+
                             std::string(" order by ")+colname+
                             std::string(" limit 2 - (select count(*) from ") + tname+std::string(") % 2")+
                             std::string(" offset (select (count(*) - 1) / 2")+
                             std::string(" from ") + tname+ std::string("))") );
  }

  double rms( sqlite3* db, const std::string& tname, const std::string& colname ){
    double const ms = query_db<double>( db,
                                        std::string("select sum(")+
                                        std::string("(") + colname + std::string("-(select avg(") + colname + std::string(") from ") + tname + std::string("))") +
                                        std::string("*") +
                                        std::string("(") + colname + std::string("-(select avg(") + colname + std::string(") from ") + tname + std::string("))") +
                                        std::string(" ) /") +
                                        std::string("(count(") + colname +std::string(")) from ") + tname );
    return std::sqrt( ms );
  }

} // namespace sqlite

