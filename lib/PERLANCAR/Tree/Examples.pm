package PERLANCAR::Tree::Examples;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Exporter::Rinci qw(import);

our %SPEC;

$SPEC{gen_sample_tree} = {
    v => 1.1,
    summary => 'Generate sample tree object',
    args => {
        size => {
            summary => 'Which tree to generate',
            schema => ['str*', in=>['tiny1', 'small1', 'medium1']],
            description => <<'_',

There are several predefined sizes to choose from.

`tiny1` is a very tiny tree, with only depth of 2 and a total of 3 nodes,
including root node.

`small1` is a small tree with depth of 4 and a total of 16 nodes, including root
node.

`medium1` is a tree of depth 7 and ~20k nodes, which is about the size of
`Org::Document` tree generated when parsing my `todo.org` document circa early
2016 (~750kB, ~2900 todo items).

_
            req => 1,
            pos => 0,
        },
        backend => {
            schema => ['str*', in=>['array', 'hash']],
            default => 'hash',
        },
    },
    result => {
        schema => 'obj*',
    },
    result_naked => 1,
};
sub gen_sample_tree {
    my %args = @_;

    my $size = $args{size} or die "Please specify size";
    my $backend = $args{backend} // 'hash';

    my ($c, $c1, $c2) = @_;
    if ($backend eq 'array') {
        $c  = "Tree::Example::ArrayNode";
        $c1 = "Tree::Example::ArrayNode::Sub1";
        $c2 = "Tree::Example::ArrayNode::Sub2";
    } else {
        $c  = "Tree::Example::HashNode";
        $c1 = "Tree::Example::HashNode::Sub1";
        $c2 = "Tree::Example::HashNode::Sub2";
    }

    if ($size eq 'tiny1') {
        require Tree::FromStruct;
        return Tree::FromStruct::build_tree_from_struct({
            _class => $c, id => 1, level => 0, _children => [
                {id=>2, level=>1},
                {id=>3, level=>1},
            ],
        });
    } elsif ($size eq 'small1') {
        require Tree::Create::Size;
        my $id = 1;
        return Tree::Create::Size::create_tree(
            num_nodes_per_level => [3, 2, 8, 2],
            class => $c, # unused because we use code_instantiate_node
            code_create_node => sub {
                my ($cl, $lvl, $parent) = @_;
                if ($lvl==0) { $cl=$c } elsif ($lvl % 2) { $cl=$c1 } else { $cl=$c2 }
                $cl->new(id => $id++, level => $lvl);
            },
        );
    } elsif ($size eq 'medium1') {
        require Tree::Create::Size;
        my $id = 1;
        return Tree::Create::Size::create_tree(
            num_nodes_per_level => [100, 3000, 5000, 8000, 3000, 1000, 300],
            class => $c, # unused because we use code_instantiate_node
            code_create_node => sub {
                my ($cl, $lvl, $parent) = @_;
                if ($lvl==0) { $cl=$c } elsif ($lvl % 2) { $cl=$c1 } else { $cl=$c2 }
                $cl->new(id => $id++, level => $lvl);
            },
        );
    } else {
        die "Unknown size '$size'";
    }
}

package # hide from PAUSE
    Tree::Example::HashNode;
use parent qw(Tree::Object::Hash);

sub id    { $_[0]{id}    = $_[1] if @_>1; $_[0]{id}    }
sub level { $_[0]{level} = $_[1] if @_>1; $_[0]{level} }

package # hide from PAUSE
    Tree::Example::HashNode::Sub1;
use base qw(Tree::Example::HashNode);

package # hide from PAUSE
    Tree::Example::HashNode::Sub2;
use base qw(Tree::Example::HashNode);

package # hide from PAUSE
    Tree::Example::ArrayNode;
use Tree::Object::Array::Glob qw(id level);

package # hide from PAUSE
    Tree::Example::ArrayNode::Sub1;
use base qw(Tree::Example::ArrayNode);

package # hide from PAUSE
    Tree::Example::ArrayNode::Sub2;
use base qw(Tree::Example::ArrayNode);

1;
# ABSTRACT:

=head1 SYNOPSIS

 use PERLANCAR::Tree::Examples qw(gen_sample_tree);

 my $tree = gen_sample_tree(size => 'medium1');


=head1 DESCRIPTION

This distribution can generate sample tree objects of several size (depth +
number of nodes) and implementation (hash-based nodes or array-based). I use
these example trees for benchmarking or testing in several other distributions.
