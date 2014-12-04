#ifndef GROUP_INCLUDED
#define GROUP_INCLUDED

#include <vector>
#include <unordered_map>

/**
Returns an unordered_map with keys for each unique element in
the iterator range mapped to a vector containing the index for
each occurrence of that key
**/
template< typename Iter,
            typename T = typename std::iterator_traits<Iter>::value_type >
inline std::unordered_map< T, std::vector<unsigned long> > group( Iter begin, Iter end ){
    std::unordered_map< T, std::vector<unsigned long> > map;
    unsigned long i = 0;
    T elem;
    while( begin != end ){
        elem = *begin;
        auto mapping = map.find( elem );
        if( mapping == map.end() ){
            //element is not in the map yet
            std::vector<unsigned long> indices;
            indices.push_back( i );
            map[ elem ] = indices;
        }else{
            //update indices vector
            mapping->second.push_back( i );
        }
        //increment i and begin
        ++begin;
        ++i;
    }
    return map;
}

/**
Returns the grouping of indices corresponding to each unique element in the iterator
**/
template< typename Iter,
            typename T = typename std::iterator_traits<Iter>::value_type >
inline std::vector< std::vector< unsigned long > > groupIndices( Iter begin, Iter end ){
    std::unordered_map< T , std::vector< unsigned long > > map = group( begin, end );
    std::vector < std::vector < unsigned long > > grouping;
    for( auto i = map.begin() ; i != map.end() ; ++i ){
        grouping.push_back( i->second );
    }
    return grouping;

}

#endif
